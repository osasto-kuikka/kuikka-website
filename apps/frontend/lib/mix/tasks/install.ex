defmodule Mix.Tasks.Frontend.Install do
  @moduledoc """
  Install npm packages with yarn.

  Incase you dont have yarn installed it can be installed with npm
      npm install -g yarnpkg
  """

  @doc "Install frontend npm packages with yarn"
  def run(_) do
    Mix.Shell.IO.cmd("cd apps/frontend && npm install")
  end
end
