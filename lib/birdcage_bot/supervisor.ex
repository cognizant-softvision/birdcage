defmodule BirdcageBot.Supervisor do
  @moduledoc false

  use Supervisor

  require Logger

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    config = Vapor.load!(BirdcageBot.Config)

    case config.bot.enabled do
      true ->
        Logger.info("Starting Birdcage Slack bot (#{config.bot.name}).")

        children = [
          {Fawkes,
           name: BirdcageBot,
           bot_name: config.bot.name,
           bot_alias: config.bot.alias,
           brain: {Fawkes.Brain.InMemory, []},
           adapter: {Fawkes.Adapter.Slack, [token: config.bot.slack_token]},
           handlers: [
             {BirdcageBot.Handlers.Flagger, app_url: config.bot.app_url}
           ]}
        ]

        Supervisor.init(children, strategy: :one_for_one)

      _ ->
        Logger.info("Birdcage Slack bot disabled.")

        :ignore
    end
  end
end
