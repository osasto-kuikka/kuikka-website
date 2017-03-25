defmodule Frontend.Page.MemberController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  alias KuikkaDB.Users
  alias Steamex.Profile
  alias Plug.Conn
  alias HTTPoison.Response
  alias Frontend.Utils

  @doc """
  List all users.
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"logout" => "true"}) do
    conn
    |> fetch_session
    |> delete_session(:steamid64)
    |> put_flash(:info, dgettext("member", "You have been logged out"))
    |> redirect(to: home_path(conn, :index))
  end
  def index(conn, %{"login" => "true"}) do
      conn
      |> Conn.fetch_query_params()
      |> Map.get(:query_params, nil)
      |> validate_payload()
      |> case do
        {:ok, steamid64} ->
          conn
          |> Conn.put_session(:steamid64, steamid64)
          |> put_flash(:info, "Logged in succesfully")
          |> redirect(to: home_path(conn, :index))
        {:error, msg} ->
          conn
          |> put_flash(:error, "Failed to login: #{msg}")
          |> redirect(to: home_path(conn, :index))
      end
  end
  def index(conn, _) do
    with {:ok, users} <- Users.members_list()
    do
      conn
      |> assign(:members, Enum.map(users, &add_profile(&1)))
      |> render("member_list.html")
    else
      _ ->
        conn
        |> put_flash(:error, dgettext("member", "Failed to load members"))
        |> assign(:members, [])
        |> render("member_list.html")
    end
  end

  @doc """
  Show profile page of one user
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => id}) do
    with {id, ""} <- Integer.parse(id),
         {:ok, [member]} <- Users.get_with_role(id)
    do
      conn
      |> assign(:member, add_profile(member))
      |> render("member.html")
    else
      _ ->
        conn
        |> put_flash(:error, dgettext("member", "Failed to load members"))
        |> redirect(to: member_path(conn, :index))
    end
  end

  defp add_profile(user) do
    steamid = Decimal.to_integer(user.steamid)
    Map.put(user, :profile, Profile.fetch(steamid))
  end

  defp validate_payload(payload) do
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
    url = Utils.steam_login_url_base()
    HTTPoison.post(url, URI.encode_query(params), [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ])
  end
end
