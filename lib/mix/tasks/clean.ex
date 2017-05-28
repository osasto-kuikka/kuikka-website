defmodule Mix.Tasks.Npm.Clean do
  @moduledoc """
  Install npm packages required for frontend
  """

  @doc "Install frontend npm packages"
  @spec run(term) :: term
  def run(_) do
    File.rm_rf("assets/node_modules")
  end
end
