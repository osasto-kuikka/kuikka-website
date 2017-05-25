defmodule KuikkaDB.Repo.Migrations.CreateWikiAccessTable do
  use Ecto.Migration

  def change do
    create table(:wikipage_users) do
      add :user_schema_id, references(:users), null: false
      add :wikipage_schema_id, references(:wikipages), null: false
      add :read, :boolean, null: false
      add :edit, :boolean, null: false
    end
  end
end
