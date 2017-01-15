defmodule KuikkaDB.Repo.Migrations.CreateForumTables do
  use Ecto.Migration

  def change do
    create table(:topic) do
      add :title, :string, size: 255, null: false
      add :text, :string, size: 2500, null: false
      add :createtime, :datetime, null: false
      add :modifytime, :datetime
      add :user_id, references(:user), null: false
      add :category_id, references(:category), null: false
    end
  end
end
