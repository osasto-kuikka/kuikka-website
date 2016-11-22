defmodule Frontend.Auth.GetUser do
  import Plug.Conn

  require Logger

  alias KuikkaDB.Schema.User

  def init(_), do: []

  def call(conn, _options) do
    conn
    |> get_session(:steamex_steamid64)
    |> case do
      nil -> nil
      steamid -> {steamid, User.one(steamid: steamid)}
    end
    |> case do
      {steamid, nil} -> assign(conn, :user, User.new(steamid))
      {_, user} -> assign(conn, :user, user)
      _ -> conn
    end
  end
end
