defmodule Frontend.Auth.RequireUser do
  @moduledoc """
  Plug for checking if user is not nil.
  When user is nil, home page will be shown with error message
  that tells user to login.
  """
  import Phoenix.Controller

  def init(_), do: []

  def call(conn, _options) do
    case conn.assigns.user do
      nil ->
        conn
        |> put_flash(:error, "Tämä sivu vaatii sisäänkirjautumisen!")
        |> redirect(to: "/")
      _ ->
        conn
    end
  end
end
