defmodule KuikkaDB.Repo.Migrations.Seeds do
  @moduledoc """
  Add seed files to kuikkadb.

  TODO:
  Should be included to table creation migrations on next migration cleanup
  """
  use Ecto.Migration
  alias KuikkaDB.Schema.{Role}

  def change do
    case Role.one(name: "user") do
      {:error, _} ->
        Role.insert(%{name: "user", description: "Basic user"})
        Role.insert(%{name: "kuikka", description: "Kuikka user"})
        Role.insert(%{name: "admin", description: "Admin user"})
      _ -> nil
    end
  end
end
