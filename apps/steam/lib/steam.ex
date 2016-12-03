defmodule Steam do
  @moduledoc """
  Steam app handles quering data from steam api
  """

  @doc """
  Transform Steam struct from steam api response

  Transform users from steam api to map or nil when not found

  When list of steamids is sent then it will return list of maps
  """
  defdelegate get_user(steamids), to: Steam.Api, as: :get_user
end
