defmodule Kuikka.Web.Plug.RequireUser do
  @moduledoc """
  Plug for setting locale if it's in session or has been defined in url
  """
  use Phoenix.Controller, namespace: Kuikka.Web
  import Plug.Conn

  alias Kuikka.Web.Router.Helpers

  @spec init(term) :: keyword
  def init(opts \\ []), do: opts

  @spec call(Plug.Conn.t, keyword) :: Plug.Conn.t
  def call(conn, _options) do
    if is_nil(conn.assigns.current_user) do
      conn
      |> put_flash(:error, "you don't have access to that page")
      |> put_status(403)
      |> redirect(to: Helpers.home_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
