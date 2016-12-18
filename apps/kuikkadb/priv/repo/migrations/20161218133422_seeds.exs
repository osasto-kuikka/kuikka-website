defmodule KuikkaDB.Repo.Migrations.Seeds do
  @moduledoc """
  Add seed files to kuikkadb.

  TODO:
  Should be included to table creation migrations on next migration cleanup
  """
  use Ecto.Migration
  alias KuikkaDB.Schema.{Role, Fireteam, Fireteamrole}

  def change do
    case Role.one(name: "user") do
      {:error, _} ->
        Role.insert(%{name: "user", description: "Basic user"})
        Role.insert(%{name: "kuikka", description: "Kuikka user"})
        Role.insert(%{name: "admin", description: "Admin user"})
      _ -> nil
    end

    fireteam = case Fireteam.one(name: "none") do
      {:error, _} ->
        Fireteam.insert(%{name: "none",
                          description: "Not part of any fireteam"})
        case Fireteam.one(name: "none") do
          {:error, _} -> nil
          {:ok, ft} -> ft
        end
      {:ok, ft} ->
        ft
    end

    case Fireteamrole.one(name: "none", fireteam_id: fireteam.id) do
      {:error, _} ->
        Fireteamrole.insert(%{name: "none",
                              description: "No role in any fireteam",
                              is_leader: false,
                              fireteam_id: fireteam.id})
      _ -> nil
    end
  end
end
