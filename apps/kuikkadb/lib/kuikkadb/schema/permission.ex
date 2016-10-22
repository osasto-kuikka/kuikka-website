defmodule KuikkaDB.Schema.Permission do
  @moduledoc """
  A module providing tables for permission:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for permissions.
  Please see permission table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.{Repo, Schema}

  schema "permission" do
    field :name, :string
    field :description, :string
    many_to_many :roles, Schema.Role, join_through: "role_permission"
    field :delete, :boolean, virtual: true
  end

  @doc """
  Add new role. SEED FILE USAGE ONLY!
  """
  def new(params) do
    %__MODULE__{} |> changeset(params) |> Repo.insert
  end

  @doc """
  Delete fireteam role
  """
  def delete(struct) do
    struct |> changeset(%{delete: true}) |> Repo.update
  end

  @doc """
  Get one permission with id or name
  """
  def one(id: id),
    do: Repo.get(__MODULE__, id)
  def one(opts),
    do: Repo.get_by(__MODULE__, opts)

  @doc """
  Get all permissions
  """
  def all(),
    do: Repo.all(__MODULE__)

  defp changeset(permission, params) when is_map(params) do
    permission
    |> cast(params, [:name,:description])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
