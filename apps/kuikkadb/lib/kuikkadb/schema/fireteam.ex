defmodule KuikkaDB.Schema.Fireteam do
  @moduledoc """
  A module providing tables by using:
  [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for fireteams.
  Please see fireteam table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias KuikkaDB.{Repo, Schema}
  alias Schema.{User, Fireteamrole}

  schema "fireteam" do
    field :name, :string
    field :description, :string
    has_many :fireteamroles, Fireteamrole
    has_many :users, User
    field :delete, :boolean, virtual: true
  end

  @doc """
  Add new fireteam.
  """
  def new(params) do
    params = Map.put(params, :new, true)
    %__MODULE__{} |> changeset(params) |> Repo.insert
  end

  @doc """
  Update fireteam
  """
  def update(schema =  %__MODULE__{}, params) when is_map(params) do
    params = Map.put(params, :new, false)
    schema |> changeset(params) |> Repo.update
  end

  @doc """
  Delete fireteam
  """
  def delete(schema =  %__MODULE__{}) do
    schema |> changeset(%{delete: true}) |> Repo.delete
  end

  @doc """
  Get one fireteam with id or name
  """
  def one(id: id),
    do: Repo.get(__MODULE__, id)
  def one(opts),
    do: Repo.get_by(__MODULE__, opts)

  @doc """
  Get all fireteams
  """
  def all(),
    do: Repo.all(__MODULE__)

  defp changeset(fireteam, params) when is_map(params) do
    fireteam
    |> cast(params, [:name, :description, :delete])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> changeset_delete
  end
  defp changeset_delete(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
