defmodule KuikkaDB.Repo.Migrations.AddDefaultCategory do
  use Ecto.Migration

  alias KuikkaDB.{Repo, CategorySchema}

  def up do
    insert("Uncategorized", "No category defined", "111111")
    insert("Offtopic", "Offtopic conversation", "4CAF50")
    insert("Admin", "Admin only conversation", "F44336")
  end

  def down do
    delete("Uncategorized")
    delete("Offtopic")
    delete("Admin")
  end

  defp insert(name, description, color) do
    %CategorySchema{
      name: name,
      description: description,
      color: color
    } |> Repo.insert!()
  end

  defp delete(name) do
    case Repo.get_by(CategorySchema, name: name) do
      nil -> nil
      role -> Repo.delete!(role)
    end
  end
end
