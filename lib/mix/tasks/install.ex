defmodule Mix.Tasks.Npm.Install do
  use Mix.Task
  @shortdoc "Install frontend npm packages"
  @moduledoc """
  Install npm packages required for frontend

  ## Examples
  ```
  mix npm.install
  mix npm.install package
  mix npm.install package package2 ...
  ```
  """

  @spec run([binary]) :: any
  def run(packages) do
    System.cmd "npm", ["install"] ++ packages,
      cd: "assets",
      into: IO.stream(:stdio, :line)
  end
end
