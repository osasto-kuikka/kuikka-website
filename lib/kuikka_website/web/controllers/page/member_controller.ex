defmodule KuikkaWebsite.Web.Page.MemberController do
  use KuikkaWebsite.Web, :controller

  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, _params) do
    render conn, "show.html"
  end

  @spec create(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def create(conn, _params) do
    render conn, "show.html"
  end

  @spec update(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def update(conn, _params) do
    render conn, "show.html"
  end
end
