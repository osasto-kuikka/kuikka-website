defmodule KuikkaDB.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comment) do
      add :text, :string, size: 2500, null: false
      add :createtime, :datetime, null: false
      add :modifytime, :datetime
      add :user_id, references(:user), null: false
    end
  end
end
