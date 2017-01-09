defmodule Mix.Tasks.Frontend.Build do
  @moduledoc """
  Build npm packages for frontend.
  """

  @doc "Build npm packages and digest them for phoenix"
  def run(_) do
    Mix.Shell.IO.cmd("cd apps/frontend && npm run deploy")
    Mix.Shell.IO.cmd("cd apps/frontend && mix phoenix.digest")
  end
end
