defmodule Frontend.Home.RosterController do
  use Frontend.Web, :controller
  plug :put_layout, "shared.html"

  def get(conn, _params) do
    render conn, "roster.html"
  end
end

