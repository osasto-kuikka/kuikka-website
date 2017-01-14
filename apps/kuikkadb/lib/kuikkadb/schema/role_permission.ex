defmodule KuikkaDB.Schema.RolePermission do
  @moduledoc """
  A module providing tables for role permission:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for role permissions.
  Please see rolePermission table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.Repo

  schema "role_permission" do
    belongs_to :role, KuikkaDB.Schema.Role
    belongs_to :permission, KuikkaDB.Schema.Permission
  end

  @required [:role_id, :permission_id]

  @doc """
  Validate changes to role permission
  """
  def changeset(role_permission, params) do
    role_permission
    |> cast(params, @required)
    |> foreign_key_constraint(:role_id)
    |> foreign_key_constraint(:permission_id)
  end

  @doc """
  Insert new role permission to database
  """
  def insert(params), do: %__MODULE__{} |> changeset(params) |> Repo.insert

  @doc """
  Update role permission to database
  """
  def update(schema, params), do: schema |> changeset(params) |> Repo.update

  @doc """
  Get one role permission from database
  """
  def one(id: id), do: __MODULE__ |> Repo.get(id) |> one_tuple
  def one(opts), do: __MODULE__ |> Repo.get_by(opts) |> one_tuple
  defp one_tuple(nil), do: {:error, "Failed to find role_permission"}
  defp one_tuple(user), do: {:ok, user}

  @doc """
  Get all role permissions from database
  """
  def all(), do: Repo.all(__MODULE__)
end
