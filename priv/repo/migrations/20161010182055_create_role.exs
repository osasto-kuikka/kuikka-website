defmodule KuikkaDB.Repo.Migrations.CreateRole do
  @moduledoc """
  A module providing tables
  by using [Migration](https://hexdocs.pm/ecto/Ecto.Migration.html)

  This table is for creating roles
  which is used to specify different level of users in webpage,
  for example moderator
  Parameters are:
    - name Name of the fireteam. Must have, can't be null must be unique.
    - description of the group.
  """
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :text, null: false
      add :description, :text, null: true
    end
    create index(:roles, [:name], unique: true)
  end
end
