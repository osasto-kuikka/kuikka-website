defmodule Kuikka.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :text, null: false
      add :content, :text, null: false
      add :date, :utc_datetime, null: false

      add :creator_id, references(:members), null: false
      add :modified_id, references(:members)

      timestamps()
    end

    create table(:event_members) do
      add :event_id, references(:forums), null: false
      add :member_id, references(:members), null: false
    end
    create index(:event_members, [:event_id, :member_id], unique: true)
  end
end
