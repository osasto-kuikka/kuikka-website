defmodule Frontend.Page.HomeController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  @doc """
  Home page controller.
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, _params) do
    render conn, "home.html"
  end
end
