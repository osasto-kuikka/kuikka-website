defmodule Frontend.Auth.RequireUser do
  import Phoenix.Controller

  def init(_), do: []

  def call(conn, _options) do
    case conn.assigns.user do
      nil ->
        conn
        |> put_flash(:error, "This page requires to be logged in!")
        |> redirect(to: "/")
      _ ->
        conn
    end
  end
end
