defmodule Frontend.Home.ForumController do
  use Frontend.Web, :controller
  plug :put_layout, "shared.html"

  def get(conn, _params) do
    render conn, "forum.html"
  end
end
