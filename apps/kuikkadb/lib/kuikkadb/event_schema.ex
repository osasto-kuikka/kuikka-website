defmodule KuikkaDB.EventSchema do
  @moduledoc """
  ## Table
  ```
  :title, :string, size: 255, null: false
  :content, :string, size: 5000, null: false
  :date, :utc_datetime, null: false
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "events" do
    field :title, :string
    field :content, :string
    field :date, :utc_datetime
    many_to_many :comments, KuikkaDB.CommentSchema,
                                                join_through: "event_comments"
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:title, :content, :date])
    |> validate_required([:title, :content, :date])
    |> validate_length(:title, min: 1)
    |> validate_length(:content, min: 1)
    |> validate_date()
    |> add_comment(params["comment"])
  end

  defp validate_date(changeset) do
    case get_change(changeset, :date) do
      nil -> changeset
      date -> validate_date(changeset, date)
    end
  end
  defp validate_date(changeset, date) do
    case Timex.compare(date, Timex.now()) do
      -1 ->
        add_error(changeset, :date, "Event date must greater than current time")
      0 ->
        add_error(changeset, :date, "Event date must greater than current time")
      1 ->
        changeset
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
