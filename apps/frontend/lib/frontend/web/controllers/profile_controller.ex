defmodule Frontend.Page.ProfileController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  @doc """
  Log user out by deleting :steamex session
  """
  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:steamex_steamid64)
    |> put_flash(:info, "Sinut on kirjattu ulos!")
    |> redirect(to: "/")
  end
end
