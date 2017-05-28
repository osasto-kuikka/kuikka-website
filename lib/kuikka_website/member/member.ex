defmodule KuikkaWebsite.Member do
  @moduledoc """
  ## Table
  ```
  :steamid, :decimal, size: 64, null: false
  :createtime, :utc_datetime, null: false
  :modifytime, :utc_datetime
  :role_id, references(:roles), null: false
  ```

  ## Index
  ```
  index(:users, :steamid, unique: true)
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "users" do
    field :steamid, :decimal
    belongs_to :role, KuikkaWebsite.Member.RoleSchema, on_replace: :raise
    has_many :forum_comments, KuikkaWebsite.Forum.Comment
    has_many :event_comments, KuikkaWebsite.Event.Comment
    field :profile, :map, virtual: true

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:steamid, :createtime, :modifytime])
    |> validate_required([:steamid])
    |> add_time()
  end

  defp add_time(changeset) do
    if is_nil(get_change(changeset, :createtime)) do
      put_change(changeset, :createtime, Timex.now())
    else
      put_change(changeset, :modifytime, Timex.now())
    end
  end
end
