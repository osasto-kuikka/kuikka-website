defmodule KuikkaDB.Repo.Migrations.CreateUser do
  @moduledoc """
  This table is created for a registered users in webpage.
  """
  use Ecto.Migration

  def change do
    create table(:users) do
      add :steamid, :decimal, size: 64, null: false
      add :createtime, :utc_datetime, default: fragment("now()"), null: false
      add :modifytime, :utc_datetime
      add :role_id, references(:roles), null: false
    end
    create index(:users, :steamid, unique: true)
  end
end
