defmodule User do
  @moduledoc """
  Defines user struct for usage to other components
  """

  alias User.{Role, Fireteam}

  defstruct [
    :username,
    :email,
    :imageurl,
    :role,
    :fireteam
  ]

  @doc """
  Transform map to user struct
  """
  def to_struct(params = %{role: role, fireteam: fireteam}) do
    params = params
             |> Map.put(:role, Role.to_struct(role))
             |> Map.put(:fireteam, Fireteam.to_struct(fireteam))
    struct!(__MODULE__, params)
  end
end
