defmodule Mix.Tasks.Npm.Build do
  @moduledoc """
  Build npm packages for frontend.
  """

  @doc "Build npm packages and digest them for phoenix"
  @spec run(term) :: term
  def run(_) do
    Mix.Shell.IO.cmd("cd assets && npm run deploy")
    Mix.Shell.IO.cmd("mix phx.digest")
  end
end
