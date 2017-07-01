defmodule Kuikka.Member do
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

  alias Steamex.Profile

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "members" do
    field :steamid, :string
    belongs_to :role, Kuikka.Member.Role, on_replace: :raise
    has_many :forum_comments, Kuikka.Forum.Comment
    has_many :event_comments, Kuikka.Event.Comment
    field :profile, :map, virtual: true

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:steamid])
    |> validate_required([:steamid])
    |> add_role(params[:role])
  end

  @doc """
  Load profile to member struct
  """
  @spec load_profile(__MODULE__.t) :: __MODULE__.t
  def load_profile(member) do
    profile =
      member.steamid
      |> String.to_integer()
      |> Profile.fetch()
    %{member | profile: profile}
  end

  defp add_role(changeset, nil), do: changeset
  defp add_role(changeset, role), do: put_assoc(changeset, :role, role)
end
