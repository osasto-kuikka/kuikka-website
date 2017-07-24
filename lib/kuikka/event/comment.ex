defmodule Kuikka.Event.Comment do
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

    belongs_to :member, Kuikka.Member, on_replace: :nilify
    belongs_to :event, Kuikka.Event, on_replace: :delete

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:content])
    |> add_assoc(:member, params)
    |> add_assoc(:event, params)
    |> validate_required([:content, :member, :event])
    |> validate_length(:content, min: 1)
    |> foreign_key_constraint(:member)
  end

  @spec add_assoc(Ecto.Changeset.t, atom, map) :: Ecto.Changeset.t
  defp add_assoc(changeset, field, params) do
    if val = params[field] || params["#{field}"] do
      put_assoc(changeset, field, val)
    else
      changeset
    end
  end
end
