defmodule Kuikka.Repo.Migrations.AddPagetypes do
  use Ecto.Migration

  def change do
    create table(:pagetypes) do
      add :name, :text
      add :description, :text
    end
  end
end
