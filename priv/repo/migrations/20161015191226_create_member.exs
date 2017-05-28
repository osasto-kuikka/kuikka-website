defmodule KuikkaDB.Repo.Migrations.CreateMember do
  @moduledoc """
  This table is created for a registered users in webpage.
  """
  use Ecto.Migration

  def change do
    create table(:members) do
      add :steamid, :decimal, size: 64, null: false
      add :role_id, references(:roles), null: false

      timestamps()
    end
    create index(:members, :steamid, unique: true)
  end
end
