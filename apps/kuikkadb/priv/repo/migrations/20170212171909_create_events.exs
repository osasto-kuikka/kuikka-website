defmodule KuikkaDB.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string, size: 255, null: false
      add :content, :string, size: 5000, null: false
      add :date, :utc_datetime, null: false
    end
  end
end
