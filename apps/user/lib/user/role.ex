defmodule User.Role do
  @moduledoc """
  Defines user role struct for usage to other components
  """
  defstruct name: nil, permissions: []

  @doc """
  Transform map to user role struct
  """
  def to_struct(params) do
    struct!(__MODULE__, params)
  end
end
