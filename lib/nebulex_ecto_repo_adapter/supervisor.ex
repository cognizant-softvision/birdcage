defmodule NebulexEctoRepoAdapter.Supervisor do
  @moduledoc false

  use Supervisor

  @cache Application.compile_env(:birdcage, [NebulexEctoRepoAdapter, :cache])

  @doc """
  Starts the Supervisor for the given `repo`.
  """
  def start_link(repo) do
    Supervisor.start_link(__MODULE__, repo)
  end

  @impl Supervisor
  def init(_repo) do
    children = [
      {@cache, []}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
