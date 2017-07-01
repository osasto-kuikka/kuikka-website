defmodule Kuikka.Repo.Migrations.AddHomepage do
  use Ecto.Migration

  def change do
    create table(:homepage) do
      add :content, :text, null: false
      add :version, :text, null: false
      add :type_id, references(:pagetypes), null: false

      timestamps()
    end
  end
end
