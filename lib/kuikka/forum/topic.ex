defmodule Kuikka.Forum.Topic do
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
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "topics" do
    field :title, :string
    field :content, :string
    belongs_to :user, Kuikka.Member, on_replace: :nilify
    belongs_to :category, Kuikka.Forum.Category, on_replace: :nilify
    many_to_many :comments, Kuikka.Forum.Comment,
                                                join_through: "topic_comments"

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    #|> cast(params, [:title, :content, :createtime, :modifytime])
    |> cast(params, [:title, :content])
    |> validate_required([:title, :content])
    |> validate_length(:title, min: 1)
    |> validate_length(:content, min: 1)
    |> add_comment(params)
  end

  defp add_comment(changeset, %{comments: comments}),
    do: put_assoc(changeset, :comments, comments)
  defp add_comment(changeset, %{"comments" => comments}),
    do: put_assoc(changeset, :comments, comments)
  defp add_comment(changeset, _),
    do: changeset
end
