defmodule KuikkaDB.Repo.Migrations.CreateEventComments do
  use Ecto.Migration

  def change do
    create table(:event_comments) do
      add :event_id, references(:events), null: false
      add :comment_id, references(:comments), null: false
    end
    create index(:event_comments, [:event_id, :comment_id], unique: true)
  end
end
