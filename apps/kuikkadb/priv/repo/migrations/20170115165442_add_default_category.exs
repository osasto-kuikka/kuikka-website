defmodule KuikkaDB.Repo.Migrations.AddDefaultCategory do
  use Ecto.Migration

  alias KuikkaDB.Categories

  @doc """
  Insert default categories
  """
  def up do
    insert_category("Uncategorized", "No category defined", "111111")
    insert_category("Offtopic", "Offtopic conversation", "4CAF50")
    insert_category("Admin", "Admin only conversation", "F44336")
  end

  @doc """
  Remove default categories
  """
  def down do
    remove_category("Uncategorized")
    remove_category("Offtopic")
    remove_category("Admin")
  end

  @spec insert_category(binary, binary, binary) ::
                                        {:ok, Ecto.Schema.t} | {:error, binary}
  defp insert_category(name, description, color) do
    Categories.insert(name: name, description: description, color: color)
  end

  @spec remove_category(binary) :: nil | :ok
  defp remove_category(name) do
    Categories.delete(name: name)
  end
end
