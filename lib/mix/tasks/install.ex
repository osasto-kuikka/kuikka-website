defmodule Mix.Tasks.Npm.Install do
  @moduledoc """
  Install npm packages required for frontend
  """

  @doc "Install frontend npm packages"
  @spec run(term) :: term
  def run(packages) do
    System.cmd "npm", ["install"] ++ packages, cd: "assets"
  end
end
