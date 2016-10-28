defmodule KuikkaDB.Schema.Role do
  @moduledoc """
  A module providing tables for role:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for roles.
  Please see role table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.{Repo, Schema}
  alias Schema.{Permission, User}

  schema "role" do
    field :name, :string
    field :description, :string
    many_to_many :permissions, Permission, join_through: "role_permission"
    has_many :users, User
    field :delete, :boolean, virtual: true
  end

  @doc """
  Add new role.
  """
  def new(params) do
    %__MODULE__{} |> changeset(params) |> Repo.insert
  end

  @doc """
  Update role
  """
  def update(schema = %__MODULE__{}, params) when is_map(params) do
    params = Map.put(params, :new, false)
    schema |> changeset(params) |> Repo.update
  end

  @doc """
  Delete role
  """
  def delete(schema = %__MODULE__{}) do
    schema |> changeset(%{delete: true}) |> Repo.delete
  end

  @doc """
  Get one role with id or name
  """
  def one(id: id),
    do: Repo.get(__MODULE__, id)
  def one(opts),
    do: Repo.get_by(__MODULE__, opts)

  @doc """
  Get all roles
  """
  def all(),
    do: Repo.all(__MODULE__)

  defp changeset(role, params) do
    role
    |> cast(params, [:name, :description, :delete])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> changeset_delete
  end
  # Delete role
  defp changeset_delete(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
