defmodule KuikkaDB.Repo.Migrations.CreateFireteamrole do
  @moduledoc """
  A module providing tables
  by using [Migration](https://hexdocs.pm/ecto/Ecto.Migration.html)

  This table is for creating roles in fireteams.
  For example Rifleman in Fireteam 1.
  Parameters are:
    - name Name of the role. Must have, can't be null must be unique.
    - description of the role.
    - is_leader Leader can specify members of the fireteam and their roles.

  Foreign key to fireteam.
  """
  use Ecto.Migration

  def change do
    create table(:fireteamrole) do
        add :fireteam_id, references(:fireteam), null: false
        add :name, :string, size: 50, null: false
        add :description, :string, size: 250, null: true
        add :is_leader, boolean null: false
    end
    create index(:fireteamrole, [:fireteam_id, :name], unique: true)
  end
end
