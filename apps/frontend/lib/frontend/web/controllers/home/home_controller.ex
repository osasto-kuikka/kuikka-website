defmodule Frontend.Home.HomeController do
  use Frontend.Web, :controller
  plug :put_layout, "home.html"

  def get(conn, %{"redirect_to" => _}) do
    IO.inspect conn.assigns
    render conn, "home.html"
  end
  def get(conn, _params) do
    IO.inspect conn.assigns
    render conn, "home.html"
  end
end
