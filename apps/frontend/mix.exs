defmodule Frontend.Mixfile do
  @moduledoc """
  Frontend mix configs
  """
  use Mix.Project

  def project do
    [app: :frontend,
     version: "0.0.1",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Frontend, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :earmark,
                    :cowboy, :logger, :gettext, :timex, :kuikkadb, :steamex,
                    :sweet_xml]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:kuikkadb, in_umbrella: true},
      {:wiki, in_umbrella: true},
      {:steamex, "~> 0.0.6"},
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.9"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.13"},
      {:cowboy, "~> 1.1"},
      {:timex, "~> 3.1"},
      {:earmark, "~> 1.1"}
    ]
  end
end
