defmodule KuikkaDB.Schema.User do
    use Ecto.Schema
    
    schema "user" do
        belongs_to :permission_id, KuikkaDB.Schema.Permission
        belongs_to :fireteam_id, KuikkaDB.Schema.Fireteam
        belongs_to :fireteamrole_id, KuikkaDB.Schema.Fireteamrole
        field :username, :string
        field :password, :string
        field :email, :string
        field :imageurl, :string
        field :signature, :string
    end
end