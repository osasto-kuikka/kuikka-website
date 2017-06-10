defmodule Mix.Tasks.Npm.Clean do
  use Mix.Task
  @shortdoc "Remove node modules folder in assets folder"
  @moduledoc """
  Remove node modules folder in assets folder

  ## Examples
  ```
  mix npm.clean
  ```
  """

  @spec run([binary]) :: any
  def run(_) do
    # Remove
    File.rm_rf("assets/node_modules")
  end
end
