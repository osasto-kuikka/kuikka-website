defmodule Frontend.Kuikka.ProfileController do
  use Frontend.Web, :controller
  plug :put_layout, "kuikka.html"

  def get(conn, _params) do
    render conn, "profile.html"
  end
end

