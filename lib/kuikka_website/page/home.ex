defmodule KuikkaWebsite.Page.Home do
  @moduledoc """
  Schema for custom homepage with version
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "homepage" do
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
