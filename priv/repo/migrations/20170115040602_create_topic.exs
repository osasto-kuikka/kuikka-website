defmodule KuikkaDB.Repo.Migrations.CreateTopic do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :title, :text, null: false
      add :content, :text, null: false
      add :createtime, :utc_datetime, default: fragment("now()"), null: false
      add :modifytime, :utc_datetime
      add :member_id, references(:members), null: false
      add :category_id, references(:categories), null: false
    end
  end
end
