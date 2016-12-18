defmodule KuikkaDB.Tasks do
  @moduledoc """
  Tasks for release build of kuikkadb are included in this module

  These tasks are meant to run on distillery hooks and are not for
  use in other parts for kuikkadb
  """
  alias Ecto.Migrator
  alias KuikkaDB.Repo

  # Get priv folder path for kuikkadb
  @priv Application.app_dir(:kuikkadb, "priv/")

  @doc """
  This task will run migrations for kuikkadb.

  ## Example for distillery hook script
  ```
  echo "Running migrations for kuikkadb"
  bin/my-app rpc Elixir.KuikkaDB.Tasks migrate
  echo "Migrations run successfully for kuikkadb"
  ```
  """
  def migrate do
    {:ok, _} = Application.ensure_all_started(:kuikkadb)

    path = Path.join([@priv, "repo", "migrations"])

    Migrator.run(Repo, path, :up, all: true)
  end
end
