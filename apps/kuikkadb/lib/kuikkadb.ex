defmodule KuikkaDB do
  @moduledoc """
  KuikkaDB application starting module
  """
  use Application

  alias KuikkaDB.Repo

  @doc """
  Start Kuikkadb supervisor application tree
  """
  @spec start(term, term) :: term
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Repo, []),
    ]

    opts = [strategy: :one_for_one, name: KuikkaDB.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
