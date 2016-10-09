defmodule KuikkaDB.Repo.Migrations.CreatePermission do
  use Ecto.Migration

  def change do
    create table(:permission) do    
        add :name, :string, size: 50, null: false
        add :description, :string, size: 250, null: true
    end
  end
end
