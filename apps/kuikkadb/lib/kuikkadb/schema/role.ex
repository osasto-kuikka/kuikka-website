defmodule KuikkaDB.Schema.Role do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for roles. Please see role table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Schema

  schema "role" do
      field :name, :string
      field :description, :string
      many_to_many :permissions, Schema.Permission, join_through: "role_permission"
      has_many :users, Schema.User
  end

  @doc """
  Generate changeset to update or insert row to role

  ## Examples

      iex> KuikkaDB.Schema.Role.changeset(%KuikkaDB.Schema.Role{},
                                          %{name: "user"})
  """
  def changeset(role, params) when is_map(params) do
      role
      |> cast(params, [:name, :description])
      |> validate_required([:name])
      |> unique_constraint(:name)
  end
end
