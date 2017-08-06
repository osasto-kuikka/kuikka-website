defmodule Kuikka.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Kuikka.Web, :controller
      use Kuikka.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """
  alias Kuikka.Web

  def controller do
    quote do
      use Phoenix.Controller, namespace: Kuikka.Web
      import Plug.Conn

      import Kuikka.Web.Router.Helpers
      import Kuikka.Web.Gettext
      import Kuikka.Web.Utils.{Auth, Controller}

      import Ecto.Query

      Web.shared()
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/kuikka/web/templates",
                        namespace: Kuikka.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2,
                                        view_module: 1]
      # Add steamex authentication
      use Steamex.Auth.Phoenix, :view

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Kuikka.Web.Router.Helpers
      import Kuikka.Web.Gettext
      import Kuikka.Web.Utils.View

      Web.shared()
    end
  end

  def router do
    quote do
      use Phoenix.Router
      use Steamex.Auth.Phoenix, :router
      import Plug.Conn
      import Phoenix.Controller

      Web.shared()
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Kuikka.Web.Gettext

      import Ecto.Query

      Web.shared()
    end
  end

  defmacro shared do
    quote do
      alias Kuikka.{
        Event,
        Forum,
        Member,
        Page,
        Settings,
        Repo
      }
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
