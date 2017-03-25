defmodule KuikkaDB.Repo.Migrations.CreatePermission do
  @moduledoc """
  A module providing tables
  by using [Migration](https://hexdocs.pm/ecto/Ecto.Migration.html)

  This table is for creating permissions to users in webpage.
  For example ability to remove post from the forum to moderators.
  Parameters are:
    - name Name of the permission. Must have, can't be null must be unique.
    - description of the permission.
  """
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :string, size: 50, null: false
      add :description, :string, size: 250, null: true
      add :no_login, :boolean, default: false, null: false
    end
    create index(:permissions, [:name], unique: true)
  end
end
