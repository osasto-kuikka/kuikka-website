defmodule Frontend.Plug.NextEvent do
  @moduledoc """
  Plug that loads next event data for banner
  """
  import Plug.Conn
  alias KuikkaDB.Events

  @spec init(term) :: List.t
  def init(_), do: []

  @doc """
  Get next event for banner
  """
  @spec call(Plug.Conn.t, term) :: Plug.Conn.t
  def call(conn, _options) do
    case Events.next_event() do
      {:ok, [event]} -> assign(conn, :next_event, event)
      _ -> assign(conn, :next_event, nil)
    end
  end
end
