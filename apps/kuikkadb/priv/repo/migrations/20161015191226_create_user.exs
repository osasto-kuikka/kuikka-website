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

        Foreing keys to role, fireteam and fireteamrole.

    """
  use Ecto.Migration

  def change do
    create table(:user) do
      add :steamid, :decimal, size: 64, null: false
      add :createtime, :datetime, null: false
      add :modifytime, :datetime
      add :role_id, references(:role), null: false
      add :fireteam_id, references(:fireteam), null: false
      add :fireteamrole_id, references(:fireteamrole), null: false
    end
    create index(:user, :steamid, unique: true)
  end
end
