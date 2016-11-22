defmodule Frontend.Auth.RequireUser do
  import Phoenix.Controller

  def init(_), do: []

  def call(conn, _options) do
    case conn.assigns.user do
      nil -> redirect(conn, to: "/")
      _ -> conn
    end
  end
end
