defmodule User do
  @moduledoc """
  Documentation for User.
  """
  require Logger
  import Ecto.Query

  alias KuikkaDB.{Repo, UserSchema, PermissionSchema}
  alias Steamex.Profile
  alias HTTPoison.Response

  @doc """
  Add profile to user schema
  """
  @spec add_profile(UserSchema.t) :: UserSchema.t
  def add_profile(user = %UserSchema{}) do
    steamid = Decimal.to_integer(user.steamid)
    %{user | profile: Profile.fetch(steamid)}
  end

  @doc """
  Check if user has required permission
  """
  @spec has_permission?(UserSchema.t | nil, String.t) :: boolean
  def has_permission?(%UserSchema{role: %{permissions: perms}}, permission)
    when is_list(perms)
  do
    Enum.any?(perms, fn perm -> perm.name == permission end)
  end
  def has_permission?(_, permission) do
    PermissionSchema
    |> where([p], not p.require_login)
    |> Repo.all()
    |> Enum.any?(fn perm -> perm.name == permission end)
  end

  @doc """
  Get steam login url base
  """
  @spec steam_login_url_base() :: String.t
  def steam_login_url_base, do: "https://steamcommunity.com/openid/login"

  @doc """
  Validate user login payload from steam
  """
  @spec validate_payload(Map.t) :: {:ok, integer} | {:error, String.t}
  def validate_payload(payload) do
    with {:ok, signed_params} <- get_signed_params(payload),
         {:ok, params} <- validate_signed_params(signed_params, payload),
         {:ok, response} <- send_login_request(params)
    do
      case response do
        %Response{status_code: 200, body: body} ->
          if String.contains? body, "is_valid:true" do
            "http://steamcommunity.com/openid/id/" <> steamid64_str =
                                                      payload["openid.identity"]

            {steamid64, ""} = Integer.parse(steamid64_str)

            {:ok, steamid64}
          else
            {:error, "Steam returned is_valid:false"}
          end
        %Response{status_code: code} ->
          {:error, "Steam returned invalid response, code: #{code}"}
      end
    end
  end

  defp get_signed_params(payload) do
    payload
    |> Map.get("openid.signed", "")
    |> String.split(",")
    |> Enum.map(&"openid.#{&1}")
    |> case do
      [] -> {:error, "failed to find any openid.signed values"}
      params -> {:ok, params}
    end
  end

  defp validate_signed_params(signed, payload) do
    handle = Map.get(payload, "openid.assoc_handle", nil)
    sig = Map.get(payload, "openid.sig", nil)
    ns = Map.get(payload, "openid.ns", nil)
    params = Map.take(payload, signed)

    cond do
      is_nil(handle) -> {:error, "openid.assoc_handle is nil"}
      is_nil(sig) -> {:error, "openid.sig is nil"}
      is_nil(ns) -> {:error, "openid.ns is nil"}
      true ->
        {:ok, Map.merge(params, %{
          "openid.assoc_handle" => handle,
          "openid.sig" => sig,
          "openid.ns" => ns,
          "openid.mode" => "check_authentication"
        })}
    end
  end

  defp send_login_request(params) do
    HTTPoison.post(steam_login_url_base(), URI.encode_query(params), [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ])
  end
end
