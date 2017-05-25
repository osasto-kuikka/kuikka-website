defmodule KuikkaDB.CommentSchema do
  @moduledoc """
  ## Table
  ```
  :text, :string, size: 2500, null: false
  :createtime, :utc_datetime, null: false
  :modifytime, :utc_datetime
  :user_id, references(:users), null: false
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "comments" do
    field :content, :string
    field :createtime, :utc_datetime
    field :modifytime, :utc_datetime
    belongs_to :user, KuikkaDB.UserSchema, on_replace: :nilify
    many_to_many :topic, KuikkaDB.TopicSchema,
                 join_through: "topic_comments",
                 on_replace: :delete
    many_to_many :event, KuikkaDB.EventSchema,
                 join_through: "event_comments",
                 on_replace: :delete
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:content, :createtime, :modifytime])
    |> validate_required(:content)
    |> validate_length(:content, min: 1, max: 2500)
    |> add_time()
    |> add_user(params["user"])
  end

  defp add_time(changeset) do
    if is_nil(get_change(changeset, :createtime)) do
      put_change(changeset, :createtime, Timex.now())
    else
      put_change(changeset, :modifytime, Timex.now())
    end
  end

  defp add_user(changeset, nil), do: changeset
  defp add_user(changeset, user), do: put_assoc(changeset, :user, user)
end
