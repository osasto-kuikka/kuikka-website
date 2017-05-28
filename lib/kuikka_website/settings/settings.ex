defmodule KuikkaWebsite.Settings do
  @moduledoc """
  ## Table
  ```
  :version, :integer, null: false
  :attributes, :map, null: false
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "settings" do
    field :version, :integer
    field :attributes, :map

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:version, :attributes])
    |> validate_required([:version, :attributes])
  end
end
