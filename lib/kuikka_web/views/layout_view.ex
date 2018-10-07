defmodule KuikkaWeb.LayoutView do
  use KuikkaWeb, :view

  alias Phoenix.Token

  @spec get_user_token(Plug.Conn.t()) :: String.t()
  def get_user_token(conn = %{assigns: %{current_user: nil}}) do
    salt = Application.get_env(:kuikka, KuikkaWeb.Endpoint)[:secret_key_base]
    Token.sign(conn, salt, nil)
  end

  def get_user_token(conn = %{assigns: %{current_user: user}}) do
    salt = Application.get_env(:kuikka, KuikkaWeb.Endpoint)[:secret_key_base]
    Token.sign(conn, salt, user.id)
  end
end
