defmodule Mix.Tasks.Frontend.Install do
  @moduledoc """
  Install npm packages required for frontend
  """

  @doc "Install frontend npm packages"
  @spec run(term) :: nil
  def run(_) do
    Mix.Shell.IO.cmd("cd apps/frontend && npm install")
  end
end
