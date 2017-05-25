defmodule Web.Page.MemberController do
  use Web, :controller
  plug :put_layout, "base.html"

  alias Plug.Conn

  @doc """
  List all users.
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"logout" => "true"}) do
    conn
    |> fetch_session
    |> delete_session(:steamid64)
    |> put_flash(:info, dgettext("member", "You have been logged out"))
    |> redirect(to: home_path(conn, :index))
  end
  def index(conn, %{"login" => "true"}) do
    conn
    |> Conn.fetch_query_params()
    |> Map.get(:query_params, nil)
    |> User.validate_payload()
    |> case do
      {:ok, steamid64} ->
        conn
        |> Conn.put_session(:steamid64, steamid64)
        |> put_flash(:info, "Logged in succesfully")
        |> redirect(to: home_path(conn, :index))
      {:error, msg} ->
        conn
        |> put_flash(:error, "Failed to login: #{msg}")
        |> redirect(to: home_path(conn, :index))
    end
  end
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @doc """
  Show profile page of one user
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, _params) do
    render(conn, "show.html")
  end
end
