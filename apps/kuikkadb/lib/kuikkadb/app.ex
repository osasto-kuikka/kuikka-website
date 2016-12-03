defmodule KuikkaDB.App do
  @moduledoc """
  KuikkaDB application starting module
  """
  use Application

  alias KuikkaDB.Repo

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Repo, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: KuikkaDB.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
