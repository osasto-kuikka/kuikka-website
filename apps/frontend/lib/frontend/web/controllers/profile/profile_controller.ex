defmodule Frontend.Profile.ProfileController do
  use Frontend.Web, :controller
  plug :put_layout, "home.html"

  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:steamex_steamid64)
    |> put_flash(:info, "Sinut on kirjattu ulos!")
    |> redirect(to: "/")
  end

  def get(conn, _params) do
    render conn, "profile.html"
  end
end

