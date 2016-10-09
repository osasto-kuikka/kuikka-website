defmodule KuikkaDB.Repo.Migrations.CreateFireteam do
  use Ecto.Migration

  def change do
    create table(:fireteam) do
        add :name, :string, size: 50
        add :description, :string, size: 250
  end
end
