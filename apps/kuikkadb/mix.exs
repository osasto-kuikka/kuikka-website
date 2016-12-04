defmodule KuikkaDB.Mixfile do
  use Mix.Project

  def project do
    [app: :kuikkadb,
     version: "0.1.0",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     deps_path: "../../deps",
     lockfile: "../../mix.lock",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     deps: deps]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:logger, :postgrex, :timex, :timex_ecto, :ecto,
                    :user, :steam],
     mod: {KuikkaDB.App, []}]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies
  defp deps do
    [
      {:user, in_umbrella: true},
      {:steam, in_umbrella: true},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.0.0"},
      {:timex, "~> 3.0"},
      {:timex_ecto, "~> 3.0"}
    ]
  end
end
