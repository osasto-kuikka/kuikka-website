# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :frontend, Frontend.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "78M8dsFA7Kw3qW5YM5JmwkqOLzaH/BB1BQhiZIhuiVpEFi6DFgoR7RuyFghgCRwO",
  render_errors: [view: Frontend.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Frontend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Fixes warning from ecto
config :frontend, ecto_repos: []

# Steamex
config :frontend, Steamex,
       redirect_to: "/members/login"

# Localization
config :frontend, Frontend.Gettext,
  default_locale: "fi"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
