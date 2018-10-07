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

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t()}

  schema "members" do
    field(:steamid, :string)
    field(:username, :string)
    field(:avatar, :string)
    field(:avatar_medium, :string)
    field(:avatar_full, :string)
    field(:url, :string)
    field(:email, :string)
    field(:locale, :string)

    belongs_to(:role, Kuikka.Member.Role, on_replace: :raise)

    has_many(:forum_comments, Kuikka.Forum.Comment)
    has_many(:event_comments, Kuikka.Event.Comment)

    field(:profile, :map, virtual: true)

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t()
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [
      :steamid,
      :username,
      :avatar,
      :avatar_medium,
      :avatar_full,
      :url,
      :email,
      :locale
    ])
    |> add_role(params[:role] || params["role"])
    |> validate_required([
      :steamid,
      :username,
      :avatar,
      :avatar_medium,
      :avatar_full,
      :url,
      :locale,
      :role
    ])
  end

  defp add_role(changeset, nil), do: changeset
  defp add_role(changeset, role), do: put_assoc(changeset, :role, role)
end
