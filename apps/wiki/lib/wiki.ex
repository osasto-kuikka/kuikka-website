defmodule Wiki do
  @moduledoc """
  Module.ule for adding new, updating or deleting wiki pages
  """

  @doc """
  Create new wiki page or update old

  ## Example
  ```
  :ok = Wiki.new("page_name", "page_content")
  ```
  """
  @spec write(String.t, String.t, String.t) :: :ok | {:error, String.t}
  def write(page, content, commit_msg) do
    path = wiki_path()
    repo = Git.new(path)

    with :ok <- File.write(Path.join(path, "#{page}.md"), content),
         {:ok, _} <- Git.add(repo, "--all"),
         {:ok, _} <- Git.commit(repo, "-m '#{commit_msg}'")
    do
      :ok
    else
      error -> err(error)
    end
  end

  @doc """
  Read wiki page
  """
  @spec read(String.t) :: {:ok, String.t} | {:error, String.t}
  def read(page) do
    wiki_path()
    |> Path.join("#{page}.md")
    |> File.read()
    |> case do
      error = {:error, _} -> err(error)
      page -> page
    end
  end

  @doc """
  Return list of all pages
  """
  @spec all() :: {:ok, List.t} | {:error, String.t}
  def all do
    wiki_path()
    |> File.ls()
    |> case do
      error = {:error, _} -> err(error)
      {:ok, pages} -> {:ok, Enum.reject(pages, fn file -> file == ".git" end)}
        pages = pages
                |> Enum.reject(fn page -> page == ".git" end)
                |> Enum.map(fn page -> Enum.at(String.split(page, "."), 0) end)
        {:ok, pages}
    end
  end

  @doc """
  Delete wiki page

  ## Example
  ```
  :ok = Wiki.delete("page", "steamid123")
  ```
  """
  @spec delete(String.t, String.t) :: :ok | {:error, String.t}
  def delete(page, steamid) do
    path = wiki_path()
    repo = Git.new(path)

    with :ok <- File.rm(Path.join(path, "#{page}.md")),
         {:ok, _} <- Git.add(repo, "--all"),
         {:ok, _} <- Git.commit(repo, "-m '#{steamid} deleted page #{page}'")
    do
      :ok
    else
      error -> err(error)
    end
  end

  @doc """
  Return wiki page change log
  """
  @spec history() :: {:ok, [String.t]}
  def history do
    path = wiki_path()
    repo = Git.new(path)

    with {:ok, logs} <- Git.log(repo, "--oneline")
    do
      logs = logs
             |> String.split("\n")
             |> Enum.map(fn log ->
                Enum.at(String.split(log, "'"), 1)
             end)
             |> Enum.reject(&is_nil(&1))
      {:ok, logs}
    else
      error -> err(error)
    end
  end

  @doc """
  Get wiki path from application configs
  """
  @spec wiki_path() :: Path.t
  def wiki_path do
    :wiki
    |> Application.get_env(:path)
    |> case do
      {:system, env} -> System.get_env(env)
      path -> path
    end
    |> Path.expand()
  end

  # Parse error tuple to error tuple with string
  @spec err({:error, term}) :: {:error, String.t}
  defp err({:error, msg}) when is_binary(msg), do: {:error, msg}
  defp err({:error, %Git.Error{message: msg}}), do: {:error, msg}
  defp err({:error, :enoent}), do: {:error, "File name does not exist"}
  defp err({:error, :enotdir}), do: {:error, "File name is not a directory"}
  defp err({:error, :enospec}), do: {:error, "No space left on the device"}
  defp err({:error, :eaccess}), do: {:error, "Missing permissions"}
  defp err({:error, :eisdir}), do: {:error, "Name of the file is directory"}
  defp err({:error, :eperm}), do: {:error, "Not allowed to remove directory"}
  defp err({:error, :einval}), do: {:error, "Filename has improper type"}
end
