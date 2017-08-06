defmodule Kuikka.Web.RoomChannel do
  use Kuikka.Web, :channel
  alias Phoenix.Socket

  @spec join(String.t, map, Socket.t) :: {:ok, Socket.t}
  def join("room:lobby", _, socket) do
    {:ok, socket}
  end
end
