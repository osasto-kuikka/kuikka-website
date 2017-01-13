defmodule Frontend.Auth.RequireUser do
  @moduledoc """
  Plug for checking if user is not nil.
  When user is nil, home page will be shown with error message
  that tells user to login.
  """
  import Phoenix.Controller

  def init(_), do: []

  def call(conn, _options) do
    err_msg = "Sivu johon yritit päästä vaatii sisäänkirjautumisen"
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
