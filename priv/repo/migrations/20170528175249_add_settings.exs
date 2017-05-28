defmodule KuikkaWebsite.Repo.Migrations.AddSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :version, :integer, null: false
      add :attributes, :map, null: false

      timestamps()
    end
  end
end
