defmodule KuikkaDB.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
        add :role_id, references(:role), null: false 
        add :fireteam_id, references(:fireteam), null: false
        add :fireteamrole_id, references(:fireteamrole), null: false
        add :username, :string, size: 50, null: false
        add :password, :string, size: 50, null: false
        add :email, :string, size: 60, null: false
      #  add :created_at, :datetime, default: fragment("now()")
      #  add :updated_at, :datetime, default: fragment("now()")
        add :imageurl, :string, size: 100, null: false
        add :signature, :string, size: 250, null: true
       
        timestamps
    end
  end
end
