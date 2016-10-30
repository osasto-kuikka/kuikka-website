defmodule User.Fireteam do
  @moduledoc """
  Defines user fireteam struct for usage to other components
  """

  defstruct [
    :name,
    :leader,
    :role,
    :roles
  ]

  @doc """
  Transform map to user role struct
  """
  def to_struct(params) do
    struct!(__MODULE__, params)
  end
end
