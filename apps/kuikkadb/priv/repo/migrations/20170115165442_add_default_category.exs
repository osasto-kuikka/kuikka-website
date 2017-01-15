defmodule KuikkaDB.Repo.Migrations.AddDefaultCategory do
  use Ecto.Migration

  alias KuikkaDB.{Repo, Schema}
  alias Schema.Category

  def up do
    insert_category("Uncategorized", "No category defined")
  end

  def down do

  end

  defp insert_category(name, description) do
    %Category{}
    |> Category.changeset(%{name: name, description: description})
    |> Repo.insert()
  end
end
