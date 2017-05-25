defmodule KuikkaDB.Repo.Migrations.CreateTopicComment do
  use Ecto.Migration

  def change do
    create table(:topic_comments) do
      add :topic_schema_id, references(:topics), null: false
      add :comment_schema_id, references(:comments), null: false
    end
    create index(:topic_comments, [:topic_schema_id, :comment_schema_id],
                                    unique: true)
  end
end
