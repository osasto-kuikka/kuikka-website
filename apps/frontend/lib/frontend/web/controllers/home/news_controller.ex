defmodule Frontend.Home.NewsController do
  use Frontend.Web, :controller
  plug :put_layout, "home.html"

  def get(conn, _params) do
    render conn, "news.html"
  end
end

