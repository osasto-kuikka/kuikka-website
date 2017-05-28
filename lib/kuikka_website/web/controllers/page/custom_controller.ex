defmodule KuikkaWebsite.Web.Page.CustomController do
  use KuikkaWebsite.Web, :controller

  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, _params) do
    render conn, "index.html"
  end

  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, _params) do
    render conn, "show.html"
  end
end
