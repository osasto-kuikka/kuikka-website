defmodule Kuikka.Web.HomeController do
  use Kuikka.Web, :controller
  import Ecto.Query

  alias Kuikka.Repo
  alias Kuikka.Page.Home

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, _params) do
    conn
    |> assign(:page, get_homepage())
    |> render("index.html")
  end

  @spec get_homepage() :: Home.t | nil
  defp get_homepage do
    Home
    |> preload([:type])
    |> order_by(desc: :version)
    |> limit(1)
    |> Repo.one()
  end
end
