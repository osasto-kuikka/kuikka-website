defmodule Kuikka.Web.LayoutView do
  use Kuikka.Web, :view

  alias Phoenix.Token

  def get_user_token(conn = %{assigns: %{current_user: nil}}) do
    salt = Application.get_env(:kuikka, Kuikka.Web.Endpoint)[:secret_key_base]
    Token.sign(conn, salt, nil)
  end
  def get_user_token(conn = %{assigns: %{current_user: user}}) do
    salt = Application.get_env(:kuikka, Kuikka.Web.Endpoint)[:secret_key_base]
    Token.sign(conn, salt, user.id)
  end
end
