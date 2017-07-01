defmodule Kuikka.Page.Layout do
  @moduledoc """
  Schema for layout page content
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Ecto.Changeset.t}

  schema "layout" do
    field :content, :string
    field :version, :string
    belongs_to :type, Kuikka.Page.Type, on_replace: :raise

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:content, :version])
    |> validate_required([:content, :version])
    |> add_type(params)
  end

  defp add_type(changeset, %{type: type}),
    do: put_assoc(changeset, :type, type)
  defp add_type(changeset, %{"type" => type}),
    do: put_assoc(changeset, :type, type)
  defp add_type(changeset, _),
    do: changeset
end
