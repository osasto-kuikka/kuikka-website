defmodule KuikkaDB.Schema.Permission do
  @moduledoc """
  A module providing tables for permission:
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Schema

  schema "permission" do
    field :name, :string
    field :description, :string
    many_to_many :roles, Schema.Role, join_through: "role_permission"
  end

  @required [:name]
  @optional [:description]
  @unique :name

  @doc """
  Validate changes to role table
  """
  def changeset(role, params) do
    role
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> unique_constraint(@unique)
  end
end
