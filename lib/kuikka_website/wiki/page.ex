defmodule KuikkaWebsite.Wiki.Page do
  @moduledoc """
  ## Table
  ```
  :title, :string, size: 50, null: false
  ```

  ## Index
  ```
  index(:wikis, :title, unique: true)
  ```
  """
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  @type return :: {:ok, t} | {:error, Changeset}

  schema "wikipages" do
    field :title, :string
    field :content, :string
    field :createtime, :utc_datetime
    field :edittime, :utc_datetime
    field :public, :boolean
    many_to_many :members, KuikkaWebsite.Member,
                                        join_through: KuikkaWebsite.Wiki.Member
  end

  @doc """
  Changeset for inserting and updating schema
  """
  @spec changeset(t, Map.t) :: Ecto.Changeset.t
  def changeset(schema = %__MODULE__{}, params \\ %{}) do
    schema
    |> cast(params, [:title, :content, :public])
    |> validate_length(:title, min: 1, max: 60)
    |> validate_length(:content, min: 1)
    |> add_time()
  end

  defp add_time(changeset) do
    if is_nil(get_change(changeset, :createtime)) do
      put_change(changeset, :createtime, Timex.now())
    else
      put_change(changeset, :modifytime, Timex.now())
    end
  end
end
