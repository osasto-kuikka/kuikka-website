defmodule Kuikka.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text, null: false

      add :member_id, references(:members), null: false
      add :event_id, references(:events)
      add :forum_id, references(:forums)
      add :wiki_id, references(:wikis)

      timestamps()
    end
  end
end
