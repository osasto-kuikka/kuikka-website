defmodule KuikkaDB.Repo.Migrations.CreateWikiTable do
  use Ecto.Migration

  def change do
    create table(:wikipages) do
      add :title, :string, length: 60, null: false
      add :content, :string, null: false
      add :createtime, :utc_datetime, null: false
      add :edittime, :utc_datetime, null: false
      add :public, :boolean, null: false
    end
  end
end
