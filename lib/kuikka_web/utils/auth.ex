defmodule KuikkaWeb.Utils.Auth do
  @moduledoc """
  Authentication functions
  """
  import Plug.Conn
  import Phoenix.Controller
  alias KuikkaWeb.Router.Helpers

  @doc """
  Plug for requiring user

  Just add this as a plug to controller to require user to be logged in

  ## Example
  ```
  plug :require_user when action in [:create, :update]
  ```
  """
  @spec require_user(Plug.Conn.t, any) :: Plug.Conn.t
  def require_user(conn, _opts \\ []) do
    if is_nil(conn.assigns.current_user) do
      # Current user is nil so redirect user to home page
      conn
      |> put_flash(:error, "login required to access this page")
      |> put_status(403)
      |> redirect(to: Helpers.home_path(conn, :index))
      |> halt()
    else
      # Current user is found so move on
      conn
    end
  end

  @spec require_permission(Plug.Conn.t, any) :: Plug.Conn.t
  def require_permission(conn, permission) do
    permissions = conn.assigns[:current_user][:permissions] || []

    if Enum.any?(permissions, &(&1.name == permission)) do
      # Permission found so move on
      conn
    else
      # Current user does not have permission to this page
      conn
      |> put_flash(:error, "you don't have permission to access this page")
      |> put_status(403)
      |> redirect(to: Helpers.home_path(conn, :index))
      |> halt()
    end
  end
end
