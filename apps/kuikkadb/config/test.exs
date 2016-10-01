use Mix.Config

config :kuikkadb, KuikkaDB.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("KUIKKADB_URL") ||
        "postgres://postgres:postgres@localhost/kuikka_test",
  pool: Ecto.Adapters.SQL.Sandbox
