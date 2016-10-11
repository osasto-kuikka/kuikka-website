defmodule KuikkaDB.Repo.Migrations.CreateFireteam do
  use Ecto.Migration

  def change do
    create table(:fireteam) do
        add :name, :string, size: 50, null: false
        add :description, :string, size: 250, null: true
    end
    create index(:fireteam, [:name], unique: true)
  end
end
