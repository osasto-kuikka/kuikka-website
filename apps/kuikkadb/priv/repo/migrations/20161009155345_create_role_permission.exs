defmodule KuikkaDB.Repo.Migrations.CreateRolePermission do
  use Ecto.Migration

  def change do
    create table(:role_permission) do
        add :role_id, references(:role), null: false
        add :permission_id, references(:permission), null: false
    end
        create index(:role_permission, [:role_id, :permission_id], unique: true)
  end
end
