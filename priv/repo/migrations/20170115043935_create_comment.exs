defmodule KuikkaDB.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text, null: false
      add :member_id, references(:members), null: false

      timestamps()
    end
  end
end
