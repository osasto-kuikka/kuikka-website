defmodule KuikkaDB do
  @moduledoc """
  KuikkaDB includes all functions to needed for website to access to database
  """
  alias KuikkaDB.Repo

  @doc """
  Send custom query to kuikkadb
  """
  def query(query = %Ecto.Query{}), do: Repo.all(query)

  @doc """
  Get one user from kuikkadb with steam id
  """
  defdelegate get_user(steamid), to: KuikkaDB.Controller

  @doc """
  Get all users from kuikkadb
  """
  defdelegate get_all_users(), to: KuikkaDB.Controller

  @doc """
  Add new user to kuikkadb with steam id
  """
  defdelegate new_user(steamid), to: KuikkaDB.Controller

  @doc """
  Add new role to kuikkadb with name and description
  """
  defdelegate new_role(name, description), to: KuikkaDB.Controller

  @doc """
  Update user role to kuikkadb with steam id and role name
  """
  defdelegate update_user_role(steamid, rolename), to: KuikkaDB.Controller
end
