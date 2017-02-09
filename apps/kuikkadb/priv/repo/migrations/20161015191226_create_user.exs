defmodule KuikkaDB.Repo.Migrations.CreateUser do
    @moduledoc """
    A module providing tables
    by using [Migration](https://hexdocs.pm/ecto/Ecto.Migration.html)

    This table is created for a registered users in webpage. parameters are:
         - username
         - password
         - email
         - imageurl Avatar displayed in webpage
         - signature 250 char long text
           to use in forums and profile page as your signature

    username, password and email are mantadory
    and username and email must be unique.

        Foreing keys to role.

    """
  use Ecto.Migration

  def change do
    create table(:users) do
      add :steamid, :decimal, size: 64, null: false
      add :createtime, :utc_datetime, default: fragment("now()"), null: false
      add :modifytime, :utc_datetime
      add :role_id, references(:roles), null: false
    end
    create index(:users, :steamid, unique: true)
  end
end
