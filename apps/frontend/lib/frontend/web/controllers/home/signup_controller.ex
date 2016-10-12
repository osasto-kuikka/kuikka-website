defmodule Frontend.Home.SignupController do
  use Frontend.Web, :controller
  plug :put_layout, "home.html"

  def get(conn, _params) do
    render conn, "signup.html"
  end

  def post(conn, _params) do
    render conn, "signup.html"
  end
end
