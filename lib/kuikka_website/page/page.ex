defmodule KuikkaWebsite.Page do
  @moduledoc """
  Schema for custom pages
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "pages" do
    field :title, :string
    field :content, :string
    field :version, :string
    belongs_to :type, KuikkaWebsite.Page.Type, on_replace: :raise

    timestamps()
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:title, :content, :version])
    |> validate_required([:title, :content, :version])
    |> add_type(params)
  end

  defp add_type(changeset, %{type: type}),
    do: put_assoc(changeset, :type, type)
  defp add_type(changeset, %{"type" => type}),
    do: put_assoc(changeset, :type, type)
  defp add_type(changeset, _),
    do: changeset
end
