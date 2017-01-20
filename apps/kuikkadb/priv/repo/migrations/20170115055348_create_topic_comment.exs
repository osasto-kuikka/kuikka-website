defmodule KuikkaDB.Repo.Migrations.CreateTopicComment do
  use Ecto.Migration

  def change do
    create table(:topic_comment) do
      add :topic_id, references(:topic), null: false
      add :comment_id, references(:comment), null: false
    end
    create index(:topic_comment, [:topic_id, :comment_id], unique: true)
  end
end
