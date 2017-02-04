defmodule Frontend.Plug.GetUser do
  @moduledoc """
  Plug that will assign user when valid steamid is stored in session

  This allows pages to check if logged in when user is not nil and use
  user struct to show avatar, username etc.
  """
  alias KuikkaDB.{Users, Roles}

  import Plug.Conn
  import Phoenix.Controller

  def init(_), do: []

  def call(conn, _options) do
    conn
    |> get_session(:steamex_steamid64)
    |> query()
    |> get_user(conn)
    |> add_profile()
    |> assign(conn)
  end

  defp query(nil), do: nil
  defp query(steamid), do: Users.get_with_role(steamid)

  defp get_user({:ok, []}, conn), do: insert(conn)
  defp get_user({:ok, [user]}, _), do: user
  defp get_user(tuple, _), do: tuple

  defp add_profile(tuple = {:error, _}), do: tuple
  defp add_profile(user) do
    steamid = Decimal.to_integer(user.steamid)
    Map.put(user, :profile, Steamex.Profile.fetch(steamid))
  end

  defp assign({:error, msg}, conn), do: assign(0, put_flash(conn, :error, msg))
  defp assign(user, conn), do: assign(conn, :user, user)

  defp insert(conn) do
    steamid = get_session(conn, :steamex_steamid64)
    {:ok, [role]} = Roles.get(name: "user")
    {:ok, [user]} = Users.insert(steamid: steamid, role_id: role.id)
    user
  end
end
