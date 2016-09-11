defmodule KuikkaWebsite.Mixfile do
  use Mix.Project

  def project do
    [apps_path: "apps",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     aliases: aliases,
     deps: deps]
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
      {:distillery, "~> 0.9"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:excoveralls, "~> 0.5", only: :test},
      {:inch_ex, "~> 0.5", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      "setup": ["deps.get", "compile"],
      "release": ["npm.install", "npm.deploy", "release"],
      "npm.install": [&npm_install/1],
      "npm.deploy": [&npm_deploy/1],
      "lint": ["credo -a --strict"]
    ]
  end

  defp npm_install(_) do
    Mix.Shell.IO.cmd("cd apps/frontend && npm install")
  end

  defp npm_deploy(_) do
    Mix.Shell.IO.cmd("cd apps/frontend && npm run deploy")
    Mix.Shell.IO.cmd("cd apps/frontend && mix phoenix.digest")
  end
end
