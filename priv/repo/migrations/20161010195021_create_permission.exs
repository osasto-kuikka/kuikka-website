defmodule KuikkaDB.Repo.Migrations.CreatePermission do
  @moduledoc """
  This table is for creating permissions to users in webpage.
  For example ability to remove post from the forum to moderators.
  Parameters are:
    - name Name of the permission. Must have, can't be null must be unique.
    - description of the permission.
  """
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :text, null: false
      add :description, :text, null: true
      add :require_login, :boolean, default: true, null: false
    end
    create index(:permissions, [:name], unique: true)
  end
end
