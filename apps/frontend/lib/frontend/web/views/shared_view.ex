defmodule Frontend.SharedView do
  use Frontend.Web, :view

  @spec banner_has_info(Plug.Conn.t) :: boolean
  def banner_has_info(conn) do
    cond do
      not is_nil(get_flash(conn, :info)) -> true
      not is_nil(get_flash(conn, :error)) -> true
      true -> false
    end
  end
end
