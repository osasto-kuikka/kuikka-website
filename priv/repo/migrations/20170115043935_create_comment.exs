defmodule KuikkaDB.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :text, null: false
      add :createtime, :utc_datetime, default: fragment("now()"), null: false
      add :modifytime, :utc_datetime
      add :member_id, references(:members), null: false
    end
  end
end
