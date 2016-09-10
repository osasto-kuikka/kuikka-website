defmodule Frontend.Home.LoginController do
  use Frontend.Web, :controller
  plug :put_layout, "home.html"

  def get(conn, _params) do
    render conn, "login.html"
  end

  def post(conn, _params) do
    render conn, "login.html"
  end
end
