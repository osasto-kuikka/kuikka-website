defmodule KuikkaDB.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string, size: 50, null: false
      add :description, :string, size: 255, null: false
      add :color, :string, size: 6, null: false
    end
    create index(:categories, :name, unique: true)
  end
end
