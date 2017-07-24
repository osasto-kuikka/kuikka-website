defmodule Kuikka.Repo.Migrations.CreateWiki do
  use Ecto.Migration

  def change do
    create table(:wikis) do
      add :content, :text, null: false

      add :creator_id, references(:members), null: false
      add :modified_id, references(:members), null: false

      timestamps()
    end
  end
end
