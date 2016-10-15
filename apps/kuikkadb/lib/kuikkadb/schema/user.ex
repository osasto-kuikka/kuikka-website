defmodule KuikkaDB.Schema.User do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for users. Please see user table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt
  import Ecto.Query, only: [from: 2]


  alias KuikkaDB.Schema

  schema "user" do
      field :username, :string
      field :password, :string
      field :email, :string
      field :imageurl, :string
      field :signature, :string
      belongs_to :role_id, Schema.Role
      belongs_to :fireteam_id, Schema.Fireteam
      belongs_to :fireteamrole_id, Schema.Fireteamrole
  end

  @doc """
  Generate changeset to update or insert row to user
  You can send passwrod here in clear text, it will be hashed on
  changeset when inserting new user or updating password

  ## Examples

      iex> KuikkaDB.Schema.RolePermission.changeset(
                                      %KuikkaDB.Schema.User{},
                                      %{username: "example",
                                        password: "example",
                                        email: "example@email.com"})
  """
  def changeset(user, params) when is_map(params) do
      user
      |> cast(params, [:username, :password, :email, :imageurl,
                       :signature, :role_id, :fireteam_id,
                       :fireteamrole_id])
      |> validate_required([:username, :email, :password])
      |> validate_format(:email, ~r/@/)
      |> foreign_key_constraint(:role_id)
      |> foreign_key_constraint(:fireteam_id)
      |> foreign_key_constraint(:fireteamrole_id)
      |> unique_constraint([:username, :email])
      |> hash_password
      |> add_default_image
      |> add_default_role
      |> add_default_fireteam
      |> add_default_fireteamrole
  end

  # TODO: Add password hashing
  defp hash_password(changeset) do
    pass = get_change(changeset, :password)
    case pass do
        nil  -> changeset
        ""   -> add_error(changeset, :password, "empty")
        pass -> change(changeset, %{password: hashpwsalt(pass)})
        apply_changes(changeset)
    end
  end

  # TODO: Add default image
  defp add_default_image(changeset) do
    "TODO: replace with proper url"
  end

  # TODO: Add default role
  defp add_default_role(changeset) do
    if fetch_field(changeset, :role_id) == :error do
        query = from r in "role",
                     where: r.name == "user",
                     select: r.id
        role_id = KuikkaDB.Repo.one(query)
        changeset = change(changeset, %{role_id: query})
        apply_changes(changeset)
    end
  end

  # TODO: Add default fireteam
  defp add_default_fireteam(changeset) do
    if fetch_field(changeset, :fireteam_id) == :error do
        query = from f in "fireteam",
                    where: f.name == "No group",
                    select: f.id
        fireteam_id = KuikkaDB.Repo.one(query)
        changeset = change(changeset, %{fireteam_id: query})
        apply_changes(changeset)
    end
  end

  # TODO: Add default fireteamrole
  defp add_default_fireteamrole(changeset) do
    if fetch_field(changeset, :fireteamrole_id) == :error do
        query = from f in "firetamrole",
            where: f.name == "No role",
            select: f.id
        fireteamrole_id = KuikkaDB.Repo.one(query)
        changeset = change(changeset, %{fireteamrole_id: query})
    end
  end
end
