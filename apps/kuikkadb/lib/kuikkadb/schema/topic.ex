defmodule KuikkaDB.Schema.Topic do
  @moduledoc """
  Database schema for comment table
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "topic" do
    field :title, :string
    field :text, :string
    field :createtime, Timex.Ecto.DateTime
    field :modifytime, Timex.Ecto.DateTime
    belongs_to :user, KuikkaDB.Schema.User
    belongs_to :category, KuikkaDB.Schema.Category
    many_to_many :comments, KuikkaDB.Schema.Comment,
                                                  join_through: "topic_comment"
  end

  @required [:title, :text, :user_id, :category_id]
  @optional [:createtime, :modifytime]

  @doc """
  Validate changes to comment
  """
  @spec changeset(Ecto.Schema.t, Map.t) :: Ecto.Changeset.t
  def changeset(topic, params) when is_map(params) do
    topic
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
    |> validate_length(:title, max: 255)
    |> validate_length(:text, max: 5000)
    |> add_timestamps()
  end
  defp add_timestamps(changeset) do
    if is_nil(get_field(changeset, :createtime)) do
      put_change(changeset, :createtime, Timex.now)
    else
      put_change(changeset, :modifytime, Timex.now)
    end
  end
end
