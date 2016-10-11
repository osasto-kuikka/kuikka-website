defmodule KuikkaDB.Schema.User do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)
  
  This Schema and changeset is for users. Please see user table for further details.
  """    
    use Ecto.Schema
    import Ecto.Changeset
    
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
    def changeset(user, params \\ %{}) do
        user
        |> cast(params, [:username, :password, :email,:imageurl, :signature, :permission_id, :fireteam_id, :fireteamrole_id])
        |> validate_required([:username, :email, :password])
        |> validate_format(:email, ~r/@/)
        |> foreing_key_constrait([:permission_id, :fireteam_id,:fireteamrole_id])
        |> unique_constraint([:username, :email])
    end
end