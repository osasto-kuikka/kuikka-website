defmodule KuikkaWebsite.Web.CustomController do
  use KuikkaWebsite.Web, :controller

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec show(Plug.Conn.t, map) :: Plug.Conn.t
  def show(conn, _params) do
    render conn, "show.html"
  end
end
