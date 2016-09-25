use Mix.Config

config :kuikkadb, KuikkaDB.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("KUIKKADB_DB") || "kuikka_test",
  username: System.get_env("KUIKKADB_USER") || "postgres",
  password: System.get_env("KUIKKADB_PASSWORD") || "postgres",
  host: System.get_env("KUIKKADB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
