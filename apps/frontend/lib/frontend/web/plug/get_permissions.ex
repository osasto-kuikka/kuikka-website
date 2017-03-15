defmodule Frontend.Plug.GetPermissions do
  @moduledoc """
  Plug for checking if user is not nil.
  When user is nil, home page will be shown with error message
  that tells user to login.
  """
  import Plug.Conn

  alias KuikkaDB.Permissions

  @spec init(term) :: List.t
  def init(_), do: []

  @spec call(Plug.Conn.t, term) :: Plug.Conn.t
  def call(conn = %{assigns: %{user: nil}}, _options) do
    case Permissions.get_no_login() do
      {:ok, perms} -> assign(conn, :permissions, to_list(perms))
      {:error, _msg} -> assign(conn, :permissions, [])
    end
  end
  def call(conn = %{assigns: %{user: user}}, _options) do
    case Permissions.get_user(user.id) do
      {:ok, perms} -> assign(conn, :permissions, to_list(perms))
      {:error, msg} ->
        IO.inspect msg
        assign(conn, :permissions, [])
    end
  end

  defp to_list(perms) do
    Enum.map(perms, fn %{name: name} -> name end) |> IO.inspect
  end
end
