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
  alias KuikkaDB.Schema.Role, as: RoleSchema
  alias KuikkaDB.Schema.Fireteam as: FireteamSchema

  schema "user" do
      field :username, :string
      field :password, :string
      field :email, :string
      field :imageurl, :string
      field :signature, :string
      belongs_to :role, Schema.Role
      belongs_to :fireteam, Schema.Fireteam
      belongs_to :fireteamrole, Schema.Fireteamrole
  end

  @doc """
  Generate changeset to update or insert row to user
  You can send passwrod here in clear text, it will be hashed on
  changeset when inserting new user or updating password

  ## Examples

      iex> KuikkaDB.Schema.User.changeset(
                                      %KuikkaDB.Schema.User{},
                                      %{username: "example",
                                        password: "example",
                                        email: "example@email.com"})
  """
  def changeset(user, params) when is_map(params) do
      user
      |> cast(params, [:username, :password, :email, :imageurl,
                       :signature, :role_id, :fireteam_id, :fireteamrole_id])
      |> cast_assoc(:role)
      |> cast_assoc(:fireteam)
      |> cast_assoc(:fireteamrole)
      |> validate_required([:username, :email, :password])
      |> validate_format(:email, ~r/@/)
      |> foreign_key_constraint(:role_id)
      |> foreign_key_constraint(:fireteam_id)
      |> foreign_key_constraint(:fireteamrole_id)
      |> unique_constraint(:username)
      |> unique_constraint(:email)
      |> hash_password
      |> add_default_image
      |> get_role
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
    changeset = change(changeset, %{imageurl: "TODO: replace with proper url"})
    apply_changes(changeset)
  end

  # TODO: Add default role
  defp add_default_role(changeset) do
    get_role(changeset)
  end
  defp get_role(changeset),
    do: RoleSchema |> KuikkaDB.Repo.get_by(name: "user") |> get_role(changeset)

  defp get_role(role = %RoleSchema{}, changeset),
    do: changeset |> put_assoc(:role, role)

  defp get_role(_, changeset),
    do: changeset |> add_error(:role,"Unable to find role user")
  # TODO: Add default fireteam
  defp add_default_fireteam(changeset) do
    if fetch_field(changeset, :fireteam_id) == :error do
        query = from f in "fireteam",
                    where: f.name == "No group",
                    select: f.id
        fireteam_query = KuikkaDB.Repo.one(query)
        fireteam = fireteam_query.id
        changeset = change(changeset, %{fireteam_id: fireteam})
        apply_changes(changeset)
    end
  end
  defp get_fireteam(changeset),
    do: FireteamSchema |> KuikkaDB.Repo.get_by(name: "No group") |> get_fireteam(changeset)

  defp get_fireteam(fireteam = %FireteamSchema{},changeset),
    do: changeset |> put_assoc(:fireteam, fireteam)

  defp get_fireteam(_, changeset),
    do: changeset |> add_error(:fireteam, "Unable to find fireteam No group")

  # TODO: Add default fireteamrole
  defp add_default_fireteamrole(changeset) do
    if fetch_field(changeset, :fireteamrole_id) == :error do
        query = from f in "fireteamrole",
            where: f.name == "No role",
            select: f.id
        fireteamrole_query = KuikkaDB.Repo.one(query)
        fireteamrole = fireteamrole_query.id
        changeset = change(changeset, %{fireteamrole_id: fireteamrole})
    end
  end

  defp get_fireteamrole(changeset),
    do: FireteamRoleSchema |> KuikkaDB.Repo.get_by(name: "Kiväärimies") |> get_fireteamrole(changeset)

  defp get_fireteamrole(fireteamrole = %FireteamRoleSchema{}, changeset),
    do: put_assoc(:fireteamrole, fireteam)

  defp get_fireteamrole(_, changeset),
    do: changeset |> add_error(fireteam, "Unable to find fireteam role Kiväärimies")

end
