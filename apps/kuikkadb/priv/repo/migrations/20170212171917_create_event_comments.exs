defmodule KuikkaDB.Repo.Migrations.CreateEventComments do
  use Ecto.Migration

  def change do
    create table(:event_comments) do
      add :event_schema_id, references(:events), null: false
      add :comment_schema_id, references(:comments), null: false
    end
    create index(:event_comments, [:event_schema_id, :comment_schema_id],
                 unique: true)
  end
end
