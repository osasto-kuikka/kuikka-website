defmodule KuikkaDB.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:category) do
      add :name, :string, size: 50, null: false
      add :description, :string, size: 255
    end
    create index(:category, :name, unique: true)
  end
end
