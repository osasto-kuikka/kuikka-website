defmodule KuikkaDB.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:category) do
      add :name, :string, size: 50, null: false
      add :description, :string, size: 255, null: false
      add :color, :string, size: 6, null: false
    end
    create index(:category, :name, unique: true)
  end
end
