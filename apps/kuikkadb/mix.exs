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
     deps: deps]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:logger, :postgrex, :ecto, :comeonin],
     mod: {KuikkaDB, []}]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies
  defp deps do
    [
      {:comeonin, "~> 2.5"},
      {:postgrex, ">= 0.0.0"},
      {:ecto, "~> 2.0.0"}
    ]
  end
end
