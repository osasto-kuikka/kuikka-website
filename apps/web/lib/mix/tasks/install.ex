defmodule Mix.Tasks.Npm.Install do
  @moduledoc """
  Install npm packages required for frontend
  """

  @doc "Install frontend npm packages"
  @spec run(term) :: term
  def run([]) do
    Mix.Shell.IO.cmd("cd apps/web/assets && npm install")
  end
  def run(list) do
    packages = Enum.join(list, " ")
    Mix.Shell.IO.cmd("cd apps/web/assets && npm install --save #{packages}")
  end
end
