defmodule Kuikka.Wiki.User do
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
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t()}

  schema "wikipage_members" do
    field(:read, :boolean)
    field(:write, :boolean)
    belongs_to(:member, Kuikka.Member)
    belongs_to(:wikipage, Kuikka.Wiki)
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:read, :write, :member_id, :wikipage_id])
    |> validate_required([:read, :write])
  end
end
