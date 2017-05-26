defmodule KuikkaWebsite.Wiki.User do
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

  schema "wikipage_members" do
    field :read, :boolean
    field :write, :boolean
    belongs_to :member, KuikkaWebsite.Member
    belongs_to :wikipage, KuikkaWebsite.Wiki.Page
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:read, :write, :member_id, :wikipage_id])
    |> validate_required([:read, :write])
  end
end
