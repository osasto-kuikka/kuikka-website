defmodule Frontend.Plug.RequireUser do
  @moduledoc """
  Plug for checking if user is not nil.
  When user is nil, home page will be shown with error message
  that tells user to login.
  """
  import Phoenix.Controller
  import Frontend.Gettext

  @spec init(term) :: List.t
  def init(_), do: []

  @spec call(Plug.Conn.t, term) :: Plug.Conn.t
  def call(conn, _options) do
    err_msg = gettext("Page you tried to access requires login")
    case conn.assigns.user do
      nil ->
        conn
        |> put_flash(:error, err_msg)
        |> redirect(to: "/")
      _ ->
        conn
    end
  end
end
