defmodule User do
  @moduledoc """
  Defines user struct for usage to other components
  """

  alias User.{Role, Fireteam}

  defstruct steam: nil,
            role: nil,
            fireteam: nil

  @doc """
  Transform map to user struct
  """
  def to_struct(params = %{steam: steam, role: role, fireteam: fireteam}) do
    params = params
             |> Map.put(:steam, Steam.to_struct(steam))
             |> Map.put(:role, Role.to_struct(role))
             |> Map.put(:fireteam, Fireteam.to_struct(fireteam))
    struct!(__MODULE__, params)
  end
end
