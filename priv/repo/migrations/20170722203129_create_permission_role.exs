defmodule Kuikka.Repo.Migrations.CreatePermissionRole do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :text, null: false
      add :description, :text, null: false

      timestamps()
    end
    create index(:permissions, [:name], unique: true)

    create table(:roles) do
      add :name, :text, null: false
      add :description, :text, null: false

      timestamps()
    end
    create index(:roles, [:name], unique: true)

    create table(:role_permissions) do
      add :role_id, references(:roles), null: false
      add :permission_id, references(:permissions), null: false

      timestamps()
    end
    create index(:role_permissions, [:role_id, :permission_id], unique: true)

    execute """
    insert into roles
      (name, description, inserted_at, updated_at)
    values
      ('admin', 'admin user', now(), now()),
      ('user', 'basic user', now(), now()),
      ('guest', 'not logged in user', now(), now())
    """
  end
end
