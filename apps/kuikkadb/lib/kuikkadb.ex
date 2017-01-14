defmodule KuikkaDB do
  @moduledoc """
  KuikkaDB includes all functions to needed for website to access to database
  """

  @doc """
  Get single user from kuikkadb as user struct.

  More info `KuikkaDB.Controller.get_user/1`
  """
  @spec get_user(binary) :: User.t | nil
  defdelegate get_user(steamid), to: KuikkaDB.Controller

  @doc """
  Get all users from kuikkadb

  More info `KuikkaDB.Controller.get_all_users/0`
  """
  @spec get_all_users() :: List.t
  defdelegate get_all_users(), to: KuikkaDB.Controller

  @doc """
  Adds new user to kuikkadb

  More info `KuikkaDB.Controller.new_user/1`
  """
  @spec new_user(binary) :: User.t
  defdelegate new_user(steamid), to: KuikkaDB.Controller

  @doc """
  Add new role to kuikkadb

  More info `KuikkaDB.Controller.new_role/2`
  """
  @spec new_role(binary, binary) :: :ok
  defdelegate new_role(name, description), to: KuikkaDB.Controller

  @doc """
  Update user role to kuikkadb

  More info `KuikkaDB.Controller.update_user_role/2`
  """
  @spec update_user_role(binary, binary) :: :ok | {:error, binary}
  defdelegate update_user_role(steamid, rolename), to: KuikkaDB.Controller

  @doc """
  Transform user schema from kuikkadb to user struct

  More info `KuikkaDB.Controller.user_schema_to_struct/1`
  """
  @spec user_schema_to_struct(KuikkaDB.Schema.User.t) :: User.t
  defdelegate user_schema_to_struct(schema), to: KuikkaDB.Controller
end
