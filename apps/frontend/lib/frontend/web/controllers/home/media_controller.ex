defmodule Frontend.Home.MediaController do
  use Frontend.Web, :controller
  plug :put_layout, "home.html"

  def get(conn, _params) do
    render conn, "media.html"
  end
end
