defmodule Kuikka.Web.HomeController do
  use Kuikka.Web, :controller
  import Ecto.Query

  alias Kuikka.Repo
  alias Kuikka.Page.Home

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, _params) do
    render(conn, "index.html")
  end
end
