defmodule KuikkaDB.Repo.Migrations.CreateRole do
  @moduledoc """
  A module providing tables by using [Migration](https://hexdocs.pm/ecto/Ecto.Migration.html)

  This table is for creating roles, which is used to specify different level of users in webpage,
  for example moderator
  Parameters are:
    - name Name of the fireteam. Must have, can't be null must be unique.
    - description of the group.
  """
  use Ecto.Migration

  def change do
    create table(:role) do
        # delete this: add :role_permission_id, references(:permission), null: false
        add :name, :string, size: 50, null: false
        add :description, :string, size: 250, null: true
    end
    create index(:role, [:name], unique: true)
  end
end
