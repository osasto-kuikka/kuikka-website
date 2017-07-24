defmodule Kuikka.Web.Plug.CurrentUser do
  @moduledoc """
  Plug that will assign user when valid steamid is stored in session

  This allows pages to check if logged in when user is not nil and use
  user struct to show avatar, username etc.
  """
  import Plug.Conn
  import Ecto.Query

  alias Kuikka.Member
  alias Kuikka.Member.Role
  alias Kuikka.Repo

  alias Steamex.Profile

  @spec init(any) :: keyword
  def init(_), do: []

  @spec call(Plug.Conn.t, keyword) :: Plug.Conn.t
  def call(conn, _options) do
    assign(conn, :current_user, get_member(conn))
  end

  defp get_member(conn) do
    conn
    |> get_session(:steamex_steamid64)
    |> get_member_database()
  end

  @spec get_member_database(integer | nil) :: Member.t | nil
  defp get_member_database(nil) do
    nil
  end
  defp get_member_database(steamid) do
    Member
    |> preload([:forum_comments, :event_comments, role: [:permissions]])
    |> where([m], m.steamid == ^"#{steamid}")
    |> Repo.one()
    |> create_or_load(steamid)
  end

  defp create_or_load(nil, steamid) do
    %Member{}
    |> Member.changeset(create_insert_params(steamid))
    |> Repo.insert!()
  end
  defp create_or_load(member, steamid) do
    member
    |> Member.changeset(create_update_params(steamid))
    |> Repo.update!()
  end

  defp create_update_params(steamid) do
    profile = load_profile("#{steamid}")
    %{
      username: profile.steam_id,
      avatar: profile.avatar_icon,
      avatar_medium: profile.avatar_medium,
      avatar_full: profile.avatar_full,
      url: profile.custom_url || "http://steamcommunity.com/profiles/#{steamid}"
    }
  end

  defp create_insert_params(steamid) do
    role = Repo.get_by!(Role, name: "user")
    profile = load_profile("#{steamid}") |> IO.inspect

    %{
      steamid: "#{steamid}",
      username: profile.steam_id,
      avatar: profile.avatar_icon,
      avatar_medium: profile.avatar_medium,
      avatar_full: profile.avatar_full,
      url: profile.custom_url || "http://steamcommunity.com/profiles/#{steamid}",
      locale: "en",

      role: role
    } |> IO.inspect
  end

  defp load_profile(steamid) do
    steamid
    |> String.to_integer()
    |> Profile.fetch()
  end
end
