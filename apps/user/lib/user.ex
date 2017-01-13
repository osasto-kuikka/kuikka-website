defmodule User do
  @moduledoc """
  Defines user struct for usage to other components
  """
  alias User.Role

  defstruct steamid: nil,
            personaname: nil,
            profileurl: nil,
            avatar: nil,
            avatarmedium: nil,
            avatarfull: nil,
            createtime: nil,
            role: nil

  @doc """
  Transform map to user struct
  """
  def user_struct(user = %{role: role}) do
    user = Map.put(user, :role, role_struct(role))
    {:ok, struct!(__MODULE__, user)}
  end

  @doc """
  Transform role map to user role struct
  """
  defdelegate role_struct(role), to: Role, as: :to_struct
end
