defmodule KuikkaWeb.ProfileController do
  use KuikkaWeb, :controller

  plug(:require_user when action in [:logout])

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    members = Repo.all(Member)

    conn
    |> assign(:members, members)
    |> render("members.html")
  end

  @doc """
  Login path which redirect to wanted page after login

  If to param is not defined then user will be routed to home page

  ## Example
  ```
  home_path(conn, :login) # "/"
  home_path(conn, :login, %{to: "/events"}) # "/events"
  ```
  """
  @spec login(Plug.Conn.t(), map) :: Plug.Conn.t()
  def login(conn, %{"to" => to}) do
    conn
    |> put_flash(:info, "you have been logged in")
    |> redirect(to: to)
  end

  def login(conn, params) do
    login(conn, Map.put(params, "to", home_path(conn, :index)))
  end

  @doc """
  Logout path which removes steamid key from session
  """
  @spec logout(Plug.Conn.t(), map) :: Plug.Conn.t()
  def logout(conn, %{"to" => to}) do
    conn
    |> fetch_session()
    |> delete_session(:steamex_steamid64)
    |> put_flash(:info, "you have been logged out")
    |> redirect(to: to)
  end

  def logout(conn, params) do
    logout(conn, Map.put(params, "to", home_path(conn, :index)))
  end

  @doc """
  Profile path for member
  """
  @spec profile(Plug.Conn.t(), map) :: Plug.Conn.t()
  def profile(conn, %{"id" => id}) do
    current = conn.assigns.current_user

    if not is_nil(current) and id == "#{Map.get(current, :id, -1)}" do
      # For current user render current_profile page
      conn
      |> assign(:member, current)
      |> render("current.html")
    else
      # For another user render normal profile page
      Member
      |> where([u], u.id == ^id)
      |> Repo.one()
      |> case do
        nil ->
          conn
          |> put_flash(:error, "failed to find profile")
          |> put_status(404)
          |> redirect(to: profile_path(conn, :index))

        member ->
          conn
          |> assign(:member, member)
          |> render("another.html")
      end
    end
  end

  @doc """
  Update path for user
  """
  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "params" => params}) do
    Member
    |> where([u], u.id == ^id)
    |> Repo.one()
    |> Member.changeset(params)
    |> Repo.update()
    |> case do
      {:ok, member} ->
        conn
        |> put_flash(:info, "profile info updated")
        |> redirect(to: profile_path(conn, :profile, member.id))

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> render("current.html")
    end
  end
end
