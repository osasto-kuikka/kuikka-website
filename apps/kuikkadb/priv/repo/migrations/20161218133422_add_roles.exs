defmodule KuikkaDB.Repo.Migrations.AddRoles do
  @moduledoc """
  Add default roles to kuikkadb.
  """
  use Ecto.Migration

  alias KuikkaDB.{Repo, RoleSchema}

  def up do
    insert("user", "Basic User")
    insert("admin", "Admin User")
  end

  def down do
    delete("user")
    delete("admin")
  end

  defp insert(name, desc) do
    %RoleSchema{
      name: name,
      description: desc
    } |> Repo.insert!()
  end

  defp delete(name) do
    case Repo.get_by(RoleSchema, name: name) do
      nil -> nil
      role -> Repo.delete!(role)
    end
  end
end
