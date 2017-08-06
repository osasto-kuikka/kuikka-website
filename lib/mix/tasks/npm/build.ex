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

  @spec run([binary]) :: :ok | {:error, integer}
  def run(_) do
    with {_, 0} <- cmd(~w(npm run deploy), [cd: "assets"]),
         {_, 0} <- cmd(~w(mix phx.digest.clean)),
         {_, 0} <- cmd(~w(mix phx.digest))
    do
      :ok
    else
      {_, code} -> {:error, code}
    end
  end

  @spec cmd([binary], keyword) :: :ok | {:error, integer}
  defp cmd([head | tail], opts \\ []) do
    opts = [{:into, IO.stream(:stdio, :line)} | opts]
    System.cmd(head, tail, opts)
  end
end
