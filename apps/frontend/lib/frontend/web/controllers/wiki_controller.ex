defmodule Frontend.Page.WikiController do
  use Frontend.Web, :controller
  plug :put_layout, "base.html"

  @doc """
  Wiki home page controller.
  """
  alias Frontend.Utils
  @spec index(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def index(conn, %{"editor" => "true"}) do
    if Utils.has_permission?(conn, "read_wiki") do
      conn
      |> assign(:page, nil)
      |> assign(:content, "")
      |> render("editor.html")
    else
      conn
      |> put_flash(:error, dgettext("wiki", "You don't have permission to access wiki"))
      |> redirect(to: home_path(conn, :index))
   end
    end
  def index(conn, _params) do
    if Utils.has_permission?(conn, "read_wiki") do
      content = case Wiki.read("index") do
        {:ok, content} -> content
        {:error, _} -> default_index()
      end
      sidebar = case Wiki.read("sidebar") do
        {:ok, content} -> content
        {:error, _} -> default_sidebar()
      end

      conn
      |> assign(:page, "index")
      |> assign(:content, content)
      |> assign(:sidebar, sidebar)
      |> render("page.html")
    else
      conn
      |> put_flash(:error, dgettext("wiki", "You don't have permission to access wiki"))
      |> redirect(to: home_path(conn, :index))
    end
  end

  @doc """
  Wiki page controller.
  """
  @spec show(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def show(conn, %{"id" => "index", "editor" => "true"}) do
    content = case Wiki.read("index") do
      {:ok, content} -> content
      {:error, _} -> default_index()
    end

    conn
    |> assign(:page, "index")
    |> assign(:content, content)
    |> render("editor.html")
  end
  def show(conn, %{"id" => "sidebar", "editor" => "true"}) do
    conn
    |> assign(:page, "sidebar")
    |> assign(:content, get_sidebar())
    |> render("editor.html")
  end
  def show(conn, %{"id" => page, "editor" => "true"}) do
    case Wiki.read(page) do
      {:ok, content} ->
        conn
        |> assign(:page, page)
        |> assign(:content, content)
        |> render("editor.html")
      {:error, _} ->
        conn
        |> put_flash(:error, dgettext("wiki", "Failed to find page"))
        |> redirect(to: wiki_path(conn, :index))
    end
  end
  def show(conn, %{"id" => page}) do
    case Wiki.read(page) do
      {:ok, content} ->
        conn
        |> assign(:page, page)
        |> assign(:content, content)
        |> assign(:sidebar, get_sidebar())
        |> render("page.html")
      {:error, _} ->
        conn
        |> put_flash(:error, dgettext("wiki", "Failed to find page"))
        |> redirect(to: wiki_path(conn, :index))
    end
  end

  @doc """
  Create or update wiki page
  """
  @spec create(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def create(conn, %{"page" => %{"name" => "sidebar",
                                 "content" => content,
                                 "commit" => commit_msg}}) do
    case Wiki.write("sidebar", content, commit_msg) do
      :ok ->
        conn
        |> put_flash(:info, dgettext("wiki", "Sidebar updated succefully"))
        |> redirect(to: wiki_path(conn, :index))
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: wiki_path(conn, :show, "sidebar",
                                                        %{"editor" => "true"}))
    end
  end
  def create(conn, %{"page" => %{"name" => name,
                                 "content" => content,
                                 "commit" => commit_msg}}) do
    case Wiki.write(name, content, commit_msg) do
      :ok ->
        conn
        |> put_flash(:info, dgettext("wiki", "Page updated succefully"))
        |> redirect(to: wiki_path(conn, :show, name))
      {:error, msg} ->
        conn
        |> put_flash(:error, msg)
        |> redirect(to: wiki_path(conn, :show, name, %{"editor" => "true"}))
    end
  end

  @spec get_sidebar() :: String.t
  defp get_sidebar do
    case Wiki.read("sidebar") do
      {:ok, content} -> content
      {:error, _} -> default_sidebar()
    end
  end

  @spec default_index() :: String.t
  defp default_index do
    """
    # Welcome to wiki

    This is the default text for wiki. If you want to update this text just
    press edit button on the top or create new page with new page button

    ## Summary

    You can change wiki sidebar links by pressing edit sidebar button
    """
  end

  @spec default_sidebar() :: String.t
  defp default_sidebar do
    """
    # Pages
    """
  end
end
