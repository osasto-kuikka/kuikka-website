defmodule KuikkaDB.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
        add :role_id, references(:role)
        add :fireteam_id, references(:fireteam)
        add :fireteamrole_id, references(:fireteamrole)
        add :username, :string, size: 50
        add :password, :string, size: 50
        add :email, :string, size: 60
      #  add :created_at, :datetime, default: fragment("now()")
      #  add :updated_at, :datetime, default: fragment("now()")
        add :imageurl, :string, size: 100
        add :signature, :string, size: 250
       
        timestamps
  end
end
