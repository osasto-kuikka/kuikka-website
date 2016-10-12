defmodule KuikkaDB.Schema.Permission do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for permissions. Please see permission table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Schema

  schema "permission" do
      field :name, :string
      field :description, :string
      many_to_many :roles, Schema.Role, join_through: "role_permission"
  end

  @doc """
  Generate changeset to update or insert row to permission

  ## Examples

      iex> KuikkaDB.Schema.Permission.changeset(%KuikkaDB.Schema.Permission{},
                                                %{name: "example"})
  """
  def changeset(permission, params) when is_map(params) do
      permission
      |> cast(params, [:name,:description])
      |> validate_required([:name])
      |> unique_constraint(:name)
  end
end
