defmodule KuikkaWebsite.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     app: :kuikka_website,
     version: "0.0.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     aliases: aliases(),
     deps: deps()]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
      {:distillery, "~> 1.0"},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:excoveralls, "~> 0.5", only: :test},
      {:inch_ex, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.14", only: :dev},
    ]
  end

  defp aliases do
    [
      "setup": ["deps.get", "compile", "db.setup", "frontend.install"],
      "setup.min": ["deps.get", "compile"],
      "db.setup": ["ecto.create", "ecto.migrate"],
      "db.setup.quiet": ["ecto.create --quiet", "ecto.migrate --quiet"],
      "db.reset": ["ecto.drop", "db.setup"],
      "release": ["frontend.build", "release"],
      "test": ["db.setup.quiet", "test"],
      "lint": ["credo -a --strict"]
    ]
  end
end
