defmodule Frontend.Page.MemberController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  @doc """
  List all users.
  """
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, _) do
    {:ok, members} = KuikkaDB.get_all_users()

    conn
    |> assign(:members, members)
    |> render("member_list.html")
  end

  @doc """
  Show profile page of one user
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => id}) do
    with {id_i, ""} <- Integer.parse(id)
    do
      case KuikkaDB.get_user(id) do
        {:error, _} ->
          conn
          |> put_flash(:error, "Käyttäjää ei löydetty!")
          |> redirect(to: member_path(conn, :index))
        {:ok, user} ->
          conn
          |> assign(:steam_info, Steamex.Profile.fetch(id_i))
          |> assign(:profile_info, user)
          |> render("member.html")
      end
    else
      _ ->
        conn
        |> put_flash(:error, "Virheellinen käyttäjänimi")
        |> redirect(to: member_path(conn, :index))
    end
  end

  @doc """
  Log user out by deleting :steamex session
  """
  @spec login(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def login(conn, _params) do
    redirect(conn, to: "/")
  end

  @doc """
  Log user out by deleting :steamex session
  """
  @spec logout(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:steamex_steamid64)
    |> put_flash(:info, "Sinut on kirjattu ulos!")
    |> redirect(to: "/")
  end
end
