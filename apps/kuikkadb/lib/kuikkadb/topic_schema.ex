defmodule KuikkaDB.TopicSchema do
  @moduledoc """
  ## Table
  ```
  :title, :string, size: 255, null: false
  :text, :string, size: 2500, null: false
  :createtime, :utc_datetime, null: false
  :modifytime, :utc_datetime
  :user_id, references(:users), null: false
  :category_id, references(:categories), null: false
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "topics" do
    field :title, :string
    field :content, :string
    field :createtime, :utc_datetime
    field :modifytime, :utc_datetime
    belongs_to :user, KuikkaDB.UserSchema, on_replace: :nilify
    belongs_to :category, KuikkaDB.CategorySchema, on_replace: :nilify
    many_to_many :comments, KuikkaDB.CommentSchema,
                                                join_through: "topic_comments"
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:title, :content, :createtime, :modifytime])
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 1, max: 250)
    |> validate_length(:content, min: 1, max: 2500)
    |> add_time()
    |> add_comment(params["comment"])
  end

  defp add_time(changeset) do
    if is_nil(get_change(changeset, :createtime)) do
      put_change(changeset, :createtime, Timex.now())
    else
      put_change(changeset, :modifytime, Timex.now())
    end
  end

  defp add_comment(changeset, nil),
    do: changeset
  defp add_comment(changeset = %{data: %{comments: comments}}, comment)
    when is_list(comments),
    do: put_assoc(changeset, :comments, List.insert_at(comments, -1, comment))
  defp add_comment(changeset, _),
    do: add_error(changeset, :comments, "Preload comments before inserting new")
end
