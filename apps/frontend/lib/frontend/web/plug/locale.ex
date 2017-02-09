defmodule Frontend.Plug.Locale do
  @moduledoc """
  Plug for setting locale if it's in session or has been defined in url
  """
  import Plug.Conn

  @spec init(term) :: List.t
  def init(_), do: []

  @spec call(Plug.Conn.t, term) :: Plug.Conn.t
  def call(conn, _options) do
    case Map.get(conn.params, "locale", get_session(conn, :locale)) do
      nil     -> conn
      locale  ->
        Gettext.put_locale(Frontend.Gettext, locale)
        put_session(conn, :locale, locale)
    end
  end
end
