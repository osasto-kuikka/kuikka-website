defmodule KuikkaDB.Schema.Fireteamrole do
  @moduledoc """
  A module providing tables for fireteamrole:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for fireteam roles.
  Please see fireteamrole table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.{Repo, Schema}
  alias Schema.{User, Fireteam}

  schema "fireteamrole" do
    field :name, :string
    field :description, :string
    field :is_leader, :boolean
    belongs_to :fireteam, Fireteam
    has_many :users, User
    field :new, :boolean, virtual: true
    field :delete, :boolean, virtual: true
  end

  @doc """
  Add new fireteam role.
  """
  def new(params) do
    params = Map.put(params, :new, true)
    %__MODULE__{} |> changeset(params) |> Repo.insert
  end

  @doc """
  Update fireteam role
  """
  def update(struct, params) do
    params = Map.put(params, :new, true)
    struct |> changeset(params) |> Repo.update
  end

  @doc """
  Delete fireteam role
  """
  def delete(struct) do
    struct |> changeset(%{delete: true}) |> Repo.update
  end

  @doc """
  Get one fireteam role with id or name
  """
  def one(id: id),
    do: Repo.get(__MODULE__, id)
  def one(opts),
    do: Repo.get_by(__MODULE__, opts)

  @doc """
  Get all fireteam roles
  """
  def all,
    do: Repo.all(__MODULE__)

  defp changeset(fireteamrole, params) when is_map(params) do
    fireteamrole
    |> cast(params, [:name, :description, :is_leader, :fireteam_id,
                     :new, :delete])
    |> validate_required(:name)
    |> validate_required(:is_leader)
    |> unique_constraint(:name)
    |> changeset_new(params)
    |> changeset_delete
  end
  defp changeset_new(changeset, params) do
    if get_change(changeset, :new) do
      changeset
      |> put_assoc(:fireteam, params.fireteam)
    else
      changeset
    end
  end
  defp changeset_delete(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
