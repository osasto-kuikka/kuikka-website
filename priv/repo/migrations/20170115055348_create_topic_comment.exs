defmodule KuikkaDB.Repo.Migrations.CreateTopicComment do
  use Ecto.Migration

  def change do
    create table(:topic_comments) do
      add :topic_id, references(:topics), null: false
      add :comment_id, references(:comments), null: false
    end
    create index(:topic_comments, [:topic_id, :comment_id], unique: true)
  end
end
