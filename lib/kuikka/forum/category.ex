defmodule Kuikka.Forum.Category do
  @moduledoc """
  ## Table
  ```
  :name, :string, size: 50, null: false
  :description, :string, size: 255, null: false
  :color, :string, size: 6, null: false
  ```

  ## Index
  ```
  index(:categories, :name, unique: true)
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "categories" do
    field :name, :string
    field :description, :string
    field :color, :string
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:name, :description, :color])
    |> validate_required([:name, :description, :color])
    |> validate_length(:name, min: 1)
    |> validate_length(:description, min: 1)
    |> validate_length(:color, min: 6, max: 6)
  end
end
