defmodule KuikkaWebsite.Page.Type do
  @moduledoc """
  Schema for different pagetypes supported for custom pages
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "pagetypes" do
    field :name, :string
    field :description, :string
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:name, :description])
    |> validate_required([:name])
  end
end
