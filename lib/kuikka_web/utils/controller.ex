defmodule KuikkaWeb.Utils.Controller do
  @moduledoc """
  Utility functions for controller
  """
  import Plug.Conn
  import Phoenix.Controller

  alias KuikkaWeb.Router.Helpers

  @doc """
  Check that id param is correct type

  You need to define :type option

  ## Allowed types
  * :integer

  ## Other usabe options
  * :param (default "id")
  * :to (route to redirect on invalid variable, default "/")

  ## Example
  ```
  plug :param_check, type: :integer
  plug :param_check, type: :integer, param: "id", to: home_path(conn, :index)
  ```
  """
  @spec param_check(Plug.Conn.t(), keyword) :: Plug.Conn.t()
  def param_check(conn, opts \\ []) do
    param = Keyword.get(opts, :param, "id")
    to = Keyword.get(opts, :to, Helpers.home_path(conn, :index))
    type = Keyword.get(opts, :type)

    if id_is(conn.params[param], type) do
      # Id is correct
      conn
    else
      conn
      |> put_flash(:error, "invalid url")
      |> put_status(406)
      |> redirect(to: to)
    end
  end

  defp id_is(_param, nil), do: raise("missing :type parameter on id_check")
  defp id_is(nil, _), do: raise("missing parameter on params")

  defp id_is(param, :integer) do
    case Integer.parse(param) do
      {_val, ""} -> true
      _ -> false
    end
  end

  defp id_is(_param, is), do: raise("invalid is type '#{is}' given")
end
