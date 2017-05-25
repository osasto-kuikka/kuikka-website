defmodule KuikkaWebsite.Repo do
  use Ecto.Repo, otp_app: :kuikka_website

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    pool_size = case System.get_env("POOL_SIZE") do
      "" -> 10
      val -> String.to_integer(val)
    end

    opts =
      opts
      |> Keyword.put(opts, :url, System.get_env("DATABASE_URL"))
      |> Keyword.put(opts, :pool_size, pool_size)

    {:ok, opts}
  end
end
