defmodule KuikkaWebsite.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     app: :kuikka_website,
     version: "0.0.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     aliases: aliases(),
     deps: deps(),

     # Docs
     name: "Kuikka Website",
     source_url: "https://github.com/osasto-kuikka/kuikka-website",
     homepage_url: "http://osastokuikka.com",
     docs: [main: "readme",
            extras: ["README.md"]]
    ]
  end

  defp deps do
    [
      {:distillery, "~> 1.1"},
      {:credo, "~> 0.6", only: [:dev, :test]},
      {:excoveralls, "~> 0.6", only: :test},
      {:inch_ex, "~> 0.5", only: [:dev, :test]},
      {:ex_doc, "~> 0.14", only: :dev},
    ]
  end

  defp aliases do
    [
      "compile": ["compile --warnings-as-errors"],
      "setup": ["deps.get", "compile", "db.setup", "npm.install"],
      "setup.min": ["deps.get", "compile"],
      "db.setup": ["ecto.create", "ecto.migrate"],
      "db.setup.quiet": ["ecto.create --quiet", "ecto.migrate --quiet"],
      "db.reset": ["ecto.drop", "db.setup"],
      "release": ["npm.build", "release"],
      "test": ["db.setup.quiet", "test"],
      "lint": ["credo -a --strict"]
    ]
  end
end
