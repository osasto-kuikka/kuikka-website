defmodule KuikkaDB.Repo.Migrations.CreateFireteamrole do
  use Ecto.Migration

  def change do
    create table(:fireteamrole) do
        add :fireteam_id, references(:fireteam), null: false
        add :name, :string, size: 50, null: false
        add :description, :string, size: 250, null: true
        add :is_leader, boolean null: false
    end        
  end
end
