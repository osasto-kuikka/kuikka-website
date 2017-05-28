defmodule Mix.Tasks.Npm.Build do
  @moduledoc """
  Build npm packages for frontend.
  """

  @doc "Build npm packages and digest them for phoenix"
  @spec run(term) :: term
  def run(_) do
    System.cmd "npm", ["run", "deploy"], cd: "assets"
    System.cmd "mix", ["phx.digest"]
  end
end
