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
        add :username, :string, size: 50, null: false
        add :password, :string, size: 50, null: false
        add :email, :string, size: 60, null: false
        add :imageurl, :string, size: 100, null: false
        add :signature, :string, size: 250, null: true
        add :role_id, references(:role), null: false
        add :fireteam_id, references(:fireteam), null: false
        add :fireteamrole_id, references(:fireteamrole), null: false

        timestamps
    end
    create index(:user, [:email, :username, :role_id], unique: true)
  end
end
