defmodule Steam do
  @moduledoc """
  Steam api module
  """
  defstruct steamid: nil,
				    personaname: nil,
				    profileurl: nil,
				    avatar: nil,
				    avatarmedium: nil,
				    avatarfull: nil,
				    realname: nil

  @doc """
  Transform map to struct

  When User.Steam struct is sent it will be returned
  """
  def to_struct(steam = %__MODULE__{}), do: steam
  def to_struct(steam), do: struct!(__MODULE__, steam)

  @doc """
  Transform Steam struct from steam api response

  This function will return either struct `%User.Steam{}` or when value
  is invalid then `nil` will be returned
  """
  def get_user(steamids) when is_list(steamids) do
    get_user(Enum.join(steamids, ","))
  end
  def get_user(steamid) do
    api_key = Application.get_env(:steam, :api_key)
    params = "key=#{api_key}&steamids=#{steamid}"
    url = "/ISteamUser/GetPlayerSummaries/v0002/?#{params}"

    "http://api.steampowered.com#{url}"
    |> IO.inspect
    |> HTTPoison.get
    |> IO.inspect
    |> parse_response
    |> IO.inspect
    |> parse_user
  end

  defp parse_response({:ok, response}) do
    Poison.decode(response.body)
  end
  defp parse_response(tuple) do
    tuple
  end

  defp parse_user({:ok, body}) do
    from_api(body)
  end
  defp parse_user(tuple) do
    tuple
  end

  defp from_api(%{"response" => %{"players" => players}}) do
    players
    |> Enum.map(&player/1)
    |> case do
      [user] -> user
      list -> list
    end
  end
  defp from_api(_) do
    nil
  end

  defp player(map) when is_map(map) do
    %{}
    |> Map.put(:steamid, Map.get(map, "steamid"))
    |> Map.put(:personaname, Map.get(map, "personaname"))
    |> Map.put(:profileurl, Map.get(map, "profileurl"))
    |> Map.put(:avatar, Map.get(map, "avatar"))
    |> Map.put(:avatarmedium, Map.get(map, "avatarmedium"))
    |> Map.put(:avatarfull, Map.get(map, "avatarfull"))
    |> Map.put(:realname, Map.get(map, "realname"))
    |> to_struct
  end
  defp player(_) do
    nil
  end
end
