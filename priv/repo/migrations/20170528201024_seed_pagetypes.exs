defmodule KuikkaWebsite.Repo.Migrations.SeedPagetypes do
  use Ecto.Migration

  alias KuikkaWebsite.Repo
  alias KuikkaWebsite.Page.Type

  def up do
    ins("markdown")
    ins("html")
  end

  def down do
    del("markdown")
    del("html")
  end

  defp ins(name, desc \\ "") do
    %Type{}
    |> Type.changeset(%{name: name, description: desc})
    |> Repo.insert!()
  end

  defp del(name) do
    case Repo.get_by(Type, name: name) do
      nil -> nil
      type -> Repo.delete!(type)
    end
  end
end
