defmodule Kuikka.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kuikka,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),

      dialyzer: dialyzer(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        "coveralls": :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Kuikka.Application, []},
      extra_applications: [:logger, :runtime_tools, :sweet_xml]
    ]
  end

  # Dialyzer configs
  #
  # See https://github.com/jeremyjh/dialyxir for more info
  def dialyzer do
    [
      flags: [:unmatched_returns,:error_handling,:race_conditions, :no_opaque],
      ignore_warnings: ".dialyzerignore"
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0", override: true},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:earmark, "~> 1.2"},
      {:steamex, "~> 0.0.7"},
      {:distillery, "~> 1.4"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:credo, "~> 0.8.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.5.7", only: :test, runtime: false},
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "setup": ["deps.get", "compile", "ecto.setup", "npm.install"],
      "setup.min": ["deps.get", "compile"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "release": ["compile", "npm.build", "release"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
