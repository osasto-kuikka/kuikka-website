defmodule Frontend.Page.MemberController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  alias Steamex.Profile

  @doc """
  List all users.
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, _) do
    members = KuikkaDB.get_all_users()

    conn
    |> assign(:members, members)
    |> render("member_list.html")
  end

  @doc """
  Show profile page of one user
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => id}) do
    with {id_i, ""} <- Integer.parse(id)
    do
      case KuikkaDB.get_user(id) do
        nil ->
          conn
          |> put_flash(:error, gettext("Failed to find requested user"))
          |> redirect(to: member_path(conn, :index))
        user ->
          conn
          |> assign(:member, user)
          |> render("member.html")
      end
    else
      _ ->
        conn
        |> put_flash(:error, gettext("Given username is invalid"))
        |> redirect(to: member_path(conn, :index))
    end
  end

  @doc """
  Log user out by deleting :steamex session
  """
  @spec login(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def login(conn, _params) do
    redirect(conn, to: "/")
  end

  @doc """
  Log user out by deleting :steamex session
  """
  @spec logout(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:steamex_steamid64)
    |> put_flash(:info, gettext("You have been logged out"))
    |> redirect(to: "/")
  end
end
