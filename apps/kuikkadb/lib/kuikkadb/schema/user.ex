defmodule KuikkaDB.Schema.User do
  @moduledoc """
  Database schema for user table
  """
  use Ecto.Schema
  use Timex.Ecto.Timestamps
  import Ecto.Changeset

  schema "user" do
    field :steamid, :integer
    field :createtime, Timex.Ecto.DateTime
    field :modifytime, Timex.Ecto.DateTime
    belongs_to :role, KuikkaDB.Schema.Role
  end

  @required [:steamid, :role_id]
  @optional [:createtime, :modifytime]
  @unique :steamid

  @doc """
  Validate changes to user

  ## Example
  ```
  alias KuikkaDB.Schema.User, as: UserSchema

  # Insert new user
  user = %UserSchema{}
         |> UserSchema.changeset(%{steamid: "steamid", role_id: 1})
         |> KuikkaDB.Repo.insert!()

  # Edit last created user role
  user = %UserSchema{}
         |> UserSchema.changeset(%{role_id: 2})
         |> KuikkaDB.Repo.update!()
  ```
  """
  def changeset(user, params) when is_map(params) do
    user
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> unique_constraint(@unique)
    |> add_timestamps
  end
  defp add_timestamps(changeset) do
    if is_nil(get_field(changeset, :createtime)) do
      put_change(changeset, :createtime, Timex.now)
    else
      put_change(changeset, :modifytime, Timex.now)
    end
  end
end
