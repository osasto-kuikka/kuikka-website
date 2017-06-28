defmodule KuikkaWebsite.Forum.Comment do
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
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "comments" do
    field :content, :string
    belongs_to :member, KuikkaWebsite.Member, on_replace: :nilify
    many_to_many :topic, KuikkaWebsite.Forum.Topic,
                 join_through: "topic_comments",
                 on_replace: :delete
    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:content])
    |> validate_required(:content)
    |> validate_length(:content, min: 1)
    |> add_user(params["user"])
  end

  defp add_user(changeset, nil), do: changeset
  defp add_user(changeset, user), do: put_assoc(changeset, :user, user)
end
