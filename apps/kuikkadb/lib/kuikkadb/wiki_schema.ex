defmodule KuikkaDB.UserSchema do
  @moduledoc """
  ## Table
  ```
  :title, :string, size: 50, null: false
  ```

  ## Index
  ```
  index(:wikis, :title, unique: true)
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "wikis" do
    field :title, :string
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:title])
    |> validate_length(:title, min: 1, max: 50)
  end
end
