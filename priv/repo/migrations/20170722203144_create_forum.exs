defmodule Kuikka.Repo.Migrations.CreateForum do
  use Ecto.Migration

  def change do
    create table(:forums) do
      add :title, :text, null: false
      add :content, :text, null: false

      add :creator_id, references(:members), null: false
      add :modified_id, references(:members), null: false

      timestamps()
    end
  end
end
