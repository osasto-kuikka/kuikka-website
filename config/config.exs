# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :kuikka,
  ecto_repos: [Kuikka.Repo]

# Configures the endpoint
config :kuikka, KuikkaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KU/TmQnYY26fLduJxtF6VgZoFX7gQBSgRfT85VeNsu+lBulRhVtXsAvK/eB8aC26",
  render_errors: [view: KuikkaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Kuikka.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Add markdown renderer for markdown files
config :phoenix, :template_engines,
  md: PhoenixMarkdown.Engine

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
