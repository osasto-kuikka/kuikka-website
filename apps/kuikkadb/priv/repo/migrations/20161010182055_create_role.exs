defmodule KuikkaDB.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:role) do
        add :role_permission_id, references(:permission), null: false
        add :name, :string, size: 50, null: false
        add :description, :string, size: 250, null: true
    end
    create index(:role, [:role_permission_id, :name], unique: true)
  end
end
