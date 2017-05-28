defmodule KuikkaWebsite.Repo.Migrations.AddPages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :text, null: false
      add :content, :text, null: false
      add :version, :text, null: false
      add :type_id, references(:pagetypes), null: false

      timestamps()
    end
  end
end
