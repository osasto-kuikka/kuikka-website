defmodule Frontend.Plug.GetUser do
  @moduledoc """
  Plug that will assign user when valid steamid is stored in session

  This allows pages to check if logged in when user is not nil and use
  user struct to show avatar, username etc.
  """
  alias KuikkaDB.Users
  alias KuikkaDB.Roles
  alias Steamex.Profile

  import Plug.Conn
  import Phoenix.Controller

  @spec init(term) :: List.t
  def init(_), do: []

  @spec call(Plug.Conn.t, term) :: Plug.Conn.t
  def call(conn, _options) do
    conn
    |> get_session(:steamex_steamid64)
    |> query()
    |> get_user(conn)
    |> add_profile()
    |> assign(conn)
  end

  @spec query(integer | nil) :: {:ok, List.t} | nil
  defp query(nil), do: nil
  defp query(steamid), do: Users.get_with_role(steamid)

  @spec get_user(term, Plug.Conn.t) :: term
  defp get_user({:ok, []}, conn), do: insert(conn)
  defp get_user({:ok, [user]}, _), do: user
  defp get_user(tuple, _), do: tuple

  @spec add_profile(term) :: term
  defp add_profile(tuple = {:error, _}), do: tuple
  defp add_profile(nil), do: nil
  defp add_profile(user) do
    steamid = Decimal.to_integer(user.steamid)
    Map.put(user, :profile, Profile.fetch(steamid))
  end

  @spec assign(term, Plug.Conn.t) :: Plug.Conn.t
  defp assign({:error, msg}, conn), do: assign(0, put_flash(conn, :error, msg))
  defp assign(user, conn), do: assign(conn, :user, user)

  defp insert(conn) do
    steamid = get_session(conn, :steamex_steamid64)
    {:ok, [role]} = Roles.get(name: "user")
    {:ok, [user]} = Users.insert(steamid: steamid, role_id: role.id)
    user
  end
end
