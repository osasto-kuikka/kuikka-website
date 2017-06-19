defmodule KuikkaWebsite.Wiki do
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
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "wikipages" do
    field :title, :string
    field :content, :string
    field :public, :boolean

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:title, :content, :public])
    |> validate_length(:title, min: 1, max: 60)
    |> validate_length(:content, min: 1)
  end
end
