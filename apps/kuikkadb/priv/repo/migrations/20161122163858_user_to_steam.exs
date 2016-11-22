defmodule KuikkaDB.Repo.Migrations.UserToSteam do
  use Ecto.Migration

  def change do
    alter table(:user) do
      add :steamid, :decimal, size: 64, null: false
      remove :username
      remove :password
      remove :email
      remove :imageurl
      remove :signature
    end
  end
end
