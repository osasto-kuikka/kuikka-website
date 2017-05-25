defmodule KuikkaWebsite.Web.Page.MemberController do
  use KuikkaWebsite.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
