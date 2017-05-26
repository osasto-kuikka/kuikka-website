defmodule KuikkaDB.Repo.Migrations.CreateEventUsers do
  use Ecto.Migration

  def change do
    create table(:event_users) do
      add :event_id, references(:events), null: false
      add :member_id, references(:members), null: false
    end
    create index(:event_users, [:event_id, :member_id], unique: true)
  end
end
