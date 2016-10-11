defmodule KuikkaDB.Schema.Role do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)
  
  This Schema and changeset is for roles. Please see role table for further details.
  """  
    use Ecto.Schema
    import Ecto.Changeset
    
    schema "role" do
        many to many  :role_permission_id, joins_through: KuikkaDB.Schema.RolePermission
        field :name, :string
        field :description, :string    
    end
    def changeset(role, params \\  %{}) do
        role
        |> cast(params, [:name,:description, :role_permission_id])
        |> validate_required([:name])
        |> foreing_key_constrait([:role_permission_id])
        |> unique_constraint([:name, :role_permission_id])            
    end
end