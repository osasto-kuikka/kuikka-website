defmodule KuikkaDB.Repo.Migrations.CreateWikiAccessTable do
  use Ecto.Migration

  def change do
    create table(:wikipage_members) do
      add :read, :boolean, null: false
      add :edit, :boolean, null: false
      add :member_id, references(:members), null: false
      add :wikipage_id, references(:wikipages), null: false
    end
  end
end
