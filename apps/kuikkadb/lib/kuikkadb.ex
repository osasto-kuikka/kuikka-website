defmodule KuikkaDB do
  @moduledoc """
  KuikkaDB application starting module
  """
  use Application

  @doc """
  Start Kuikkadb supervisor application tree
  """
  @spec start(term, term) :: term
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
    ]

    opts = [strategy: :one_for_one, name: KuikkaDB.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
