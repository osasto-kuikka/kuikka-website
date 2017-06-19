defmodule KuikkaWebsite.Event.Comment do
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
    many_to_many :event, KuikkaWebsite.Event,
                 join_through: "event_comments",
                 on_replace: :delete

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:content, :createtime, :modifytime])
    |> validate_required(:content)
    |> validate_length(:content, min: 1)
    |> add_user(params)
  end

  defp add_user(changeset, %{user: user}),
    do: put_assoc(changeset, :user, user)
  defp add_user(changeset, %{"user" => user}),
    do: put_assoc(changeset, :user, user)
  defp add_user(changeset, _), do: changeset
end
