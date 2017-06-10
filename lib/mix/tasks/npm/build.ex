defmodule Mix.Tasks.Npm.Build do
  use Mix.Task
  @shortdoc "Build npm packages and digest them for phoenix"
  @moduledoc """
  Build npm packages for frontend.

  ## Examples
  ```
  mix npm.build
  ```
  """

  @spec run([binary]) :: any
  def run(_) do
    ## Run npm deploy on assets folder
    System.cmd "npm", ["run", "deploy"],
      cd: "assets",
      into: IO.stream(:stdio, :line)

    # Generate cache_manifest.json with phoenix digest
    System.cmd "mix", ["phx.digest"],
      into: IO.stream(:stdio, :line)
  end
end
