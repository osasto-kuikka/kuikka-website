defmodule KuikkaWebsite.Web.Plug.CurrentUser do
  @moduledoc """
  Plug that will assign user when valid steamid is stored in session

  This allows pages to check if logged in when user is not nil and use
  user struct to show avatar, username etc.
  """
  import Plug.Conn
  import Ecto.Query

  alias KuikkaWebsite.Member
  alias KuikkaWebsite.Member.Role
  alias KuikkaWebsite.Repo

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
    role = Repo.get_by!(Role, name: "user")
    %Member{}
    |> Member.changeset(%{steamid: "#{steamid}", role: role})
    |> Repo.insert!()
    |> Member.load_profile()
  end
  defp create_or_load(member, _) do
    Member.load_profile(member)
  end
end
