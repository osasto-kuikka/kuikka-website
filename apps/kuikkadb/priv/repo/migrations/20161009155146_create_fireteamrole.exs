defmodule KuikkaDB.Repo.Migrations.CreateFireteamrole do
  use Ecto.Migration

  def change do
    create table(:fireteamrole) do
        add :fireteam_id, references(:fireteam)
        add :name, :string, size: 50
        add :description, :string, size: 250
        add :is_leader, boolean
        
  end
end
