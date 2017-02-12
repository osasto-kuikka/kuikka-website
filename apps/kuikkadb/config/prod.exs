use Mix.Config

config :kuikkadb, KuikkaDB.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "KUIKKADB_URL"},
  pool_size: {:system, "KUIKKADB_POOL"}
