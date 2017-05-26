defmodule KuikkaDB.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :text, null: false
      add :content, :string, null: false
      add :date, :utc_datetime, default: fragment("now()"), null: false
    end
  end
end
