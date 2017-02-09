defmodule Frontend.Page.MemberController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  alias KuikkaDB.Users
  alias Steamex.Profile

  @doc """
  List all users.
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"logout" => "true"}) do
    conn
    |> fetch_session
    |> delete_session(:steamex_steamid64)
    |> put_flash(:info, gettext("member", "You have been logged out"))
    |> redirect(to: home_path(conn, :index))
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
end
