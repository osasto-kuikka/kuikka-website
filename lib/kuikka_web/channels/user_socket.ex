defmodule KuikkaWeb.UserSocket do
  use Phoenix.Socket
  import Ecto.Query

  alias Phoenix.Token
  alias Kuikka.Repo
  alias Kuikka.Member

  ## Channels
  channel "room:*", KuikkaWeb.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @doc """
  Connect user to websocket with token

  Token can have user id as value or nil if user has not logged in

  This will add current_user assign to channels to use

  ## Example

  # Testing user is logged in channel
  ```
  def join("room:lobby", _, socket) do
    if is_nil(socket.assigns.current_user) do
      # User is nil so allow connect but don't send data
      {:ok, socket}
    else
      # User is logged in so start after join event
      send(self(), :after_join)
      {:ok, socket}
    end
  end
  ```
  """
  @spec connect(map, Phoenix.Socket.t) :: {:ok, Phoenix.Socket.t}
  def connect(%{"token" => token}, socket) do
    user = case Token.verify(socket, salt(), token, max_age: 86_400) do
      {:ok, id} when is_integer(id) ->
        Member
        |> preload([:forum_comments, :event_comments, role: [:permissions]])
        |> where([m], m.id == ^id)
        |> Repo.one()
      _ -> nil
    end

    socket = assign(socket, :current_user, user)
    {:ok, socket}
  end
  def connect(_params, _socket) do
    :error
  end

  defp salt do
    Application.get_env(:kuikka, KuikkaWeb.Endpoint)[:secret_key_base]
  end

  @doc """
  Allow identifying socket to specific user

  Guest accounts are all under "user_socket:guest" id

  ## Example
  ```
  alias KuikkaWeb.Endpoint

  # Disconnect all guests
  Endpoint.broadcast("user_socket:guest", "disconnect", %{})

  # Dosconnect one user with id 1
  Endpoint.broadcast("user_socket:1", "disconnect", %{})
  ```
  """
  @spec id(Phoenix.Socket.t) :: String.t
  def id(%{assigns: %{current_user: nil}}), do: "user_socket:guest"
  def id(%{assigns: %{current_user: user}}), do: "user_socket:#{user.id}"
end
