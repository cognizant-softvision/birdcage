defmodule Birdcage.OIDCSupervisor do
  @moduledoc false

  use Supervisor

  require Logger

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    case Birdcage.Application.authentication_enabled?() do
      true ->
        Logger.info("Birdcage OpenID Connect authentication enabled.")

        children = [
          {OpenIDConnect.Worker, birdcage: openid_config()}
        ]

        Supervisor.init(children, strategy: :one_for_one)

      _ ->
        Logger.info("Birdcage OpenID Connect authentication disabled.")

        :ignore
    end
  end

  def openid_config do
    config = Birdcage.Application.config()

    config.openid_connect
    |> Map.to_list()
  end
end
