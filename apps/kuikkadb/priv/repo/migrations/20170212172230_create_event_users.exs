defmodule KuikkaDB.Repo.Migrations.CreateEventUsers do
  use Ecto.Migration

  def change do
    create table(:event_users) do
      add :event_id, references(:events), null: false
      add :user_id, references(:users), null: false
    end
    create index(:event_users, [:event_id, :user_id], unique: true)
  end
end
