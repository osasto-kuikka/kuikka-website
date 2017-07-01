defmodule Kuikka.Repo.Migrations.AddLayout do
  use Ecto.Migration

  def change do
    create table(:layout) do
      add :content, :text, null: false
      add :version, :text, null: false
      add :type_id, references(:pagetypes), null: false

      timestamps()
    end
  end
end
