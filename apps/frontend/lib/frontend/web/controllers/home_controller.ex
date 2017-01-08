defmodule Frontend.Page.HomeController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  def get(conn, %{"redirect_to" => _}) do
    render conn, "home.html"
  end
  def get(conn, _params) do
    render conn, "home.html"
  end
end
