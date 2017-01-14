defmodule Frontend.Plug.GetUser do
  @moduledoc """
  Plug that will assign user when valid steamid is stored in session

  This allows pages to check if logged in when user is not nil and use
  user struct to show avatar, username etc.
  """
  import Plug.Conn
  import Phoenix.Controller

  require Logger

  def init(_), do: []

  def call(conn, _options) do
    steamid = get_session(conn, :steamex_steamid64)

    steamid
    |> case do
      nil -> nil
      steamid -> KuikkaDB.new_user(steamid)
    end
    |> case do
      nil -> {:ready, assign(conn, :user, nil)}
      {:ok, _} -> KuikkaDB.get_user(steamid)
      tuple -> tuple
    end
    |> case do
      {:ready, conn} -> conn
      {:ok, user} -> assign(conn, :user, user)
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> assign(:user, nil)
    end
  end
end
