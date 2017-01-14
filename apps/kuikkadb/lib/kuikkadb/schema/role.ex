defmodule KuikkaDB.Schema.Role do
  @moduledoc """
  This Schema and changeset is for roles.
  Please see role table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Schema

  schema "role" do
    field :name, :string
    field :description, :string
    has_many :users, Schema.User
    many_to_many :permissions, Schema.Permission,
                               join_through: "role_permission"
  end

  @required [:name]
  @optional [:description]
  @unique :name

  @doc """
  Validate changes to role
  """
  def changeset(role, params) do
    role
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> unique_constraint(@unique)
  end
end
