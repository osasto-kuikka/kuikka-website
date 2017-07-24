defmodule Kuikka.Event do
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
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "events" do
    field :title, :string
    field :content, :string
    field :date, :utc_datetime

    belongs_to :creator, Kuikka.Member
    belongs_to :modified, Kuikka.Member

    has_many :comments, Kuikka.Event.Comment

    many_to_many :attending, Kuikka.Member,
      join_through: "event_members",
      on_replace: :delete

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t) :: Ecto.Changeset.t
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:title, :content, :date])
    |> add_assoc(:comments, params)
    |> add_assoc(:creator, params)
    |> add_assoc(:modified, params)
    |> add_assoc(:attending, params)
    |> validate_required([:title, :content, :date, :creator])
    |> validate_length(:title, min: 1)
    |> validate_length(:content, min: 1)
    |> validate_date()
  end

  # Validate that given date is greater than current time
  @spec validate_date(Ecto.Changeset.t) :: Ecto.Changeset.t
  defp validate_date(changeset) do
    if date = get_change(changeset, :date) do
      case DateTime.compare(get_change(changeset, :date), DateTime.utc_now()) do
        :gt -> changeset
        _ -> add_error(changeset, :date, "must greater than current date")
      end
    else
      changeset
    end
  end

  defp add_assoc(changeset, field, params) do
    if val = params[field] || params["#{field}"] do
      put_assoc(changeset, field, val)
    else
      changeset
    end
  end

  # Add comments if given in params
  @spec add_comments(Ecto.Changeset.t, map) :: Ecto.Changeset.t
  defp add_comments(changeset, params) do
    comments = params[:comments] || params["comments"]  
    if not is_nil(comments) do
      put_assoc(changeset, :comments, comments)
    else
      changeset
    end
  end
end
