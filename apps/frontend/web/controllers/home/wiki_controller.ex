defmodule Frontend.Home.WikiController do
  use Frontend.Web, :controller
  plug :put_layout, "shared.html"

  def get(conn, _params) do
    render conn, "wiki.html"
  end
end
