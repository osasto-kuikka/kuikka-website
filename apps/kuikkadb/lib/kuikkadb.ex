defmodule KuikkaDB do
  @moduledoc """
  KuikkaDB application starting module
  """
  use Application

  alias Ecto.Migrator
  alias KuikkaDB.Repo

  @doc """
  Start Kuikkadb supervisor application tree
  """
  @spec start(term, term) :: Supervisor.on_start
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Repo, [])
    ]

    opts = [strategy: :one_for_one, name: KuikkaDB.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  This task will run migrations for kuikkadb.

  ## Example for distillery hook script
  ```
  echo "Running migrations for kuikkadb"
  bin/my-app rpc Elixir.KuikkaDB migrate
  echo "Migrations run successfully for kuikkadb"
  ```
  """
  def migrate do
    {:ok, _} = Application.ensure_all_started(:kuikkadb)

    priv = Application.app_dir(:kuikkadb, "priv/")
    path = Path.join([priv, "repo", "migrations"])

    Migrator.run(Repo, path, :up, all: true)
  end
end
