defmodule KuikkaDB.Repo.Migrations.CreateRolePermission do
  @moduledoc """
  A module providing tables
  by using [Migration](https://hexdocs.pm/ecto/Ecto.Migration.html)

  This table is for creating permissions for the roles.
  foreing keys are to role and to permission:

  """
  use Ecto.Migration

  def change do
    create table(:role_permissions) do
      add :role_id, references(:roles), null: false
      add :permission_id, references(:permissions), null: false
    end
    create index(:role_permissions, [:role_id, :permission_id], unique: true)
  end
end
