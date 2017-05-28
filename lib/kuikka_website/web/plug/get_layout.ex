defmodule KuikkaWebsite.Web.Plug.GetLayout do
  @moduledoc """
  Plug for setting locale if it's in session or has been defined in url
  """
  import Plug.Conn
  import Ecto.Query

  alias KuikkaWebsite.Repo
  alias KuikkaWebsite.Page.Layout

  @spec init(term) :: keyword
  def init(_), do: []

  @spec call(Plug.Conn.t, keyword) :: Plug.Conn.t
  def call(conn, _options) do
    assign(conn, :custom_layout, get_layout())
  end

  defp get_layout do
    Layout
    |> preload([:type])
    |> order_by(desc: :version)
    |> limit(1)
    |> Repo.one()
  end
end
