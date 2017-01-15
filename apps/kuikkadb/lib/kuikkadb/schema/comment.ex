defmodule KuikkaDB.Schema.Comment do
  @moduledoc """
  Database schema for comment table
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "comment" do
    field :text, :string
    field :createtime, Timex.Ecto.DateTime
    field :modifytime, Timex.Ecto.DateTime
    belongs_to :user, KuikkaDB.Schema.User
  end

  @required [:text, :user_id]
  @optional [:createtime, :modifytime]

  @doc """
  Validate changes to comment
  """
  @spec changeset(Ecto.Schema.t, Map.t) :: Ecto.Changeset.t
  def changeset(comment, params) when is_map(params) do
    comment
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
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
