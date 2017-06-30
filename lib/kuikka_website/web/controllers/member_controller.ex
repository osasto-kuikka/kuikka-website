defmodule KuikkaWebsite.Web.MemberController do
  use KuikkaWebsite.Web, :controller

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, %{"logout" => "true"}) do
    conn
    |> fetch_session
    |> delete_session(:steamex_steamid64)
    |> put_flash(:info, dgettext("member", "You have been logged out"))
    |> redirect(to: home_path(conn, :index))
  end
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec show(Plug.Conn.t, map) :: Plug.Conn.t
  def show(conn, _params) do
    render conn, "show.html"
  end

  @spec create(Plug.Conn.t, map) :: Plug.Conn.t
  def create(conn, _params) do
    render conn, "show.html"
  end

  @spec update(Plug.Conn.t, map) :: Plug.Conn.t
  def update(conn, _params) do
    render conn, "show.html"
  end
end
