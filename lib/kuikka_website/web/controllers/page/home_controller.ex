defmodule KuikkaWebsite.Web.Page.HomeController do
  use KuikkaWebsite.Web, :controller
  import Ecto.Query

  alias KuikkaWebsite.Repo
  alias KuikkaWebsite.Page.Home

  def index(conn, _params) do
    conn
    |> assign(:page, get_homepage())
    |> render("index.html")
  end

  defp get_homepage do
    Home
    |> order_by(desc: :version)
    |> limit(1)
    |> Repo.one()
  end
end
