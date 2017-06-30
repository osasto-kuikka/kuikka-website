defmodule KuikkaWebsite.Web.Utils.Auth do
  @moduledoc """
  Authentication functions
  """
  import Plug.Conn
  import Phoenix.Controller
  alias KuikkaWebsite.Web.Router.Helpers

  @spec require_user(Plug.Conn.t, map) :: Plug.Conn.t
  def require_user(conn, _opts) do
    if is_nil(conn.assigns.current_user) do
      conn
      |> put_flash(:error, "login required to access this page")
      |> put_status(403)
      |> redirect(to: Helpers.home_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
