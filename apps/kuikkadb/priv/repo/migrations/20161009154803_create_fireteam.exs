defmodule KuikkaDB.Repo.Migrations.CreateFireteam do
  use Ecto.Migration
  @moduledoc """
  A module providing tables by using [Migration](https://hexdocs.pm/ecto/Ecto.Migration.html)

  This table is for creating fireteams, groups of people who plays together in the game. Parameters are:
    - name Name of the fireteam. Must have, can't be null must be unique.
    - description of the group.
  """

  def change do
    create table(:fireteam) do
        add :name, :string, size: 50, null: false
        add :description, :string, size: 250, null: true
    end
    create index(:fireteam, [:name], unique: true)
  end
end
