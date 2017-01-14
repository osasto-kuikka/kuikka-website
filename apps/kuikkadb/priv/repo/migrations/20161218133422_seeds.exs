defmodule KuikkaDB.Repo.Migrations.Seeds do
  @moduledoc """
  Add seed files to kuikkadb.

  TODO:
  Should be included to table creation migrations on next migration cleanup
  """
  use Ecto.Migration
  alias KuikkaDB.Repo
  alias KuikkaDB.Schema.{Role}

  # Insert role function
  defp insert_role(name, desc) do
    %Role{}
    |> Role.changeset(%{name: name, description: desc})
    |> Repo.insert()
  end

  def change do
    insert_role("user", "Basic User")
    insert_role("admin", "Admin User")
  end
end
