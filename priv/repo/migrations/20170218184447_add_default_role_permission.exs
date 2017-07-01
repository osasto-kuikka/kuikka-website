defmodule KuikkaDB.Repo.Migrations.SeedDefaultRolePermission do
  use Ecto.Migration
  import Ecto.Query

  alias Kuikka.Repo
  alias Kuikka.Member.{Role, Permission}

  def up do
    permissions = Repo.all(Permission)
    reads = Enum.filter(permissions, &String.starts_with?(&1.name, "read_"))

    Role
    |> where([r], r.name == "admin")
    |> preload(:permissions)
    |> Repo.one!()
    |> Role.changeset(%{permissions: permissions})
    |> Repo.update!()

    Role
    |> where([r], r.name == "user")
    |> preload(:permissions)
    |> Repo.one!()
    |> Role.changeset(%{permissions: reads})
    |> Repo.update!()
  end

  def down do
    Role
    |> where([r], r.name == "admin")
    |> preload(:permissions)
    |> Role.changeset(%{permissions: []})
    |> Repo.update!()

    Role
    |> where([r], r.name == "user")
    |> preload(:permissions)
    |> Role.changeset(%{permissions: []})
    |> Repo.update!()
  end
end
