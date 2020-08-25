defmodule Birdcage.Release do
  @moduledoc false

  @app :birdcage
  @steps 100
  @interval 500

  def migrate do
    load_app()

    with repos <- repos(),
         connect <- &try_to(fn -> connect(&1) end) do
      unless repos
             |> Task.async_stream(connect, timeout: @steps * @interval)
             |> Enum.all?(fn {:ok, result} -> result end) do
        raise "Database connectivity problem"
      end

      for repo <- repos do
        :ok = ensure_repo_created(repo)
        {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
      end
    end
  end

  def rollback(repo, version) do
    load_app()

    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
    {:ok, _} = Application.ensure_all_started(@app)
  end

  # Lazily execute the function specified number
  # of times, return true if the function returns {:ok, _},
  # else wait a bit and try again
  defp try_to(fun, steps \\ @steps, interval \\ @interval) do
    fun
    |> Stream.repeatedly()
    |> Stream.take(steps)
    |> Enum.reduce_while(true, fn
      {:ok, _}, _ ->
        {:halt, true}

      _, _ ->
        :timer.sleep(interval)
        {:cont, false}
    end)
  end

  # Try to connect to the database
  defp connect(repo) do
    Ecto.Adapters.SQL.query(repo, "SELECT 1")
  rescue
    e in DBConnection.ConnectionError -> e
  end

  defp ensure_repo_created(repo) do
    IO.puts("==> Create #{inspect(repo)} database if it doesn't exist")

    case repo.__adapter__.storage_up(repo.config) do
      :ok ->
        IO.puts("*** Database created! ***")
        :ok

      {:error, :already_up} ->
        IO.puts("==> Database already exist <(^_^)>")
        :ok

      {:error, term} ->
        {:error, term}
    end
  end
end
