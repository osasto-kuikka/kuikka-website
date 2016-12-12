defmodule Steam.Api do
  @moduledoc """
  Steam api module
  """

  @doc """
  Transform Steam struct from steam api response
  """
  def get_user(steamids) when is_list(steamids) do
    get_user(Enum.join(steamids, ","))
  end
  def get_user(steamid) do
    api_query(Application.get_env(:steam, :api_key, nil), steamid)
  end

  defp api_query(nil,_), do: {:error, "Missing STEAM_API_KEY"}
  defp api_query(apikey, steamid) do
    params = "key=#{apikey}&steamids=#{steamid}"
    url = "/ISteamUser/GetPlayerSummaries/v0002/?#{params}"

    with {:ok, resp} <- HTTPoison.get("http://api.steampowered.com#{url}"),
         {:ok, resp} <- Poison.decode(resp.body)
    do
      parse_response(resp, steamid)
    end
  end

  defp parse_response(%{"response" => %{"players" => players}}, steamid) do
    players
    |> Enum.map(&parse_player/1)
    |> case do
      [] -> {:error, "No player found with #{steamid}}"}
      [player] -> {:ok, player} # Remove player from list when only one player
      list -> {:ok, list}
    end
  end
  defp parse_response(_) do
    {:error, "Invalid response returned from api"}
  end

  defp parse_player(map) do
    %{}
    |> Map.put(:steamid, Map.get(map, "steamid"))
    |> Map.put(:personaname, Map.get(map, "personaname"))
    |> Map.put(:profileurl, Map.get(map, "profileurl"))
    |> Map.put(:avatar, Map.get(map, "avatar"))
    |> Map.put(:avatarmedium, Map.get(map, "avatarmedium"))
    |> Map.put(:avatarfull, Map.get(map, "avatarfull"))
    |> Map.put(:realname, Map.get(map, "realname"))
  end
end
