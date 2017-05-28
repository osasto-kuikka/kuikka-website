defmodule KuikkaWebsite.Web.Plug.GetLayout do
  @moduledoc """
  Plug for setting locale if it's in session or has been defined in url
  """
  import Plug.Conn
  import Ecto.Query

  alias KuikkaWebsite.Repo
  alias KuikkaWebsite.Page.Layout

  @spec init(term) :: List.t
  def init(_), do: []

  @spec call(Plug.Conn.t, term) :: Plug.Conn.t
  def call(conn, _options) do
    assign(conn, :custom_layout, get_layout())
  end

  defp get_layout do
    Layout
    |> order_by(desc: :version)
    |> limit(1)
    |> Repo.one()
  end
end
