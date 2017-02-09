defmodule KuikkaDB.Repo.Migrations.CreateForumTables do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :title, :string, size: 255, null: false
      add :text, :string, size: 2500, null: false
      add :createtime, :utc_datetime, default: fragment("now()"), null: false
      add :modifytime, :utc_datetime
      add :user_id, references(:users), null: false
      add :category_id, references(:categories), null: false
    end
  end
end
