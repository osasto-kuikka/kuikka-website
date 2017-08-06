defmodule Kuikka.Repo.Migrations.CreateMember do
  use Ecto.Migration

  def change do
    create table(:members) do
      add :steamid, :text, null: false
      add :username, :text, null: false
      add :avatar, :text, null: false
      add :avatar_medium, :text, null: false
      add :avatar_full, :text, null: false
      add :url, :text, null: false
      add :email, :text
      add :locale, :text, null: false

      add :role_id, references(:roles), null: false

      timestamps()
    end
    create index(:members, [:steamid], unique: true)
    create index(:members, [:email], unique: true)
  end
end
