defmodule Frontend.Page.MemberController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  @doc """
  List all users.
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, _) do
    conn
    |> render("member_list.html")
  end

  @doc """
  Show profile page of one user
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => _id}) do
    conn
    |> render("member.html")
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
    |> put_flash(:info, "Sinut on kirjattu ulos!")
    |> redirect(to: "/")
  end
end
