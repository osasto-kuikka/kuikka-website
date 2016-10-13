defmodule KuikkaDB.Schema.User do
  @moduledoc """
  A module providing tables by using [Schema](https://hexdocs.pm/ecto/Ecto.Schema.html)
  and [Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html)

  This Schema and changeset is for users. Please see user table for further details.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt

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
    hash = hashpwsalt(fetch_field(changeset, :password))
    changeset = change(changeset, %{password: hash})
    apply_changes(changeset)
  end

  # TODO: Add default image
  defp add_default_image(changeset) do
    changeset
  end

  # TODO: Add default role
  defp add_default_role(changeset) do
    drole_id = fetch_field(KuikkaDB.Role.Changeset, :role_id)
    changeset = change(changeset, %{role_id: drole_id })

  end

  # TODO: Add default fireteam
  defp add_default_fireteam(changeset) do
    changeset
  end

  # TODO: Add default fireteam
  defp add_default_fireteamrole(changeset) do
    changeset
  end
end
