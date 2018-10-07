defmodule KuikkaWeb do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use KuikkaWeb, :controller
      use KuikkaWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """
  def controller do
    quote do
      use Phoenix.Controller, namespace: KuikkaWeb
      import Plug.Conn

      import KuikkaWeb.Router.Helpers
      import KuikkaWeb.Gettext
      import KuikkaWeb.Utils.{Auth, Controller}

      import Ecto.Query

      KuikkaWeb.shared()
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/kuikka_web/templates",
        namespace: KuikkaWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]
      # Add steamex authentication
      use Steamex.Auth.Phoenix, :view

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import KuikkaWeb.Router.Helpers
      import KuikkaWeb.Gettext
      import KuikkaWeb.Utils.View

      KuikkaWeb.shared()
    end
  end

  def router do
    quote do
      use Phoenix.Router
      use Steamex.Auth.Phoenix, :router
      import Plug.Conn
      import Phoenix.Controller

      KuikkaWeb.shared()
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import KuikkaWeb.Gettext

      import Ecto.Query

      KuikkaWeb.shared()
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
