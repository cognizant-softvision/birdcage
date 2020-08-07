defmodule BirdcageBot.Handlers.Flagger do
  @moduledoc false

  @behaviour Fawkes.EventHandler

  alias Fawkes.Bot
  alias Fawkes.Event.Message

  def init(_opts, state) do
    {:ok, state}
  end

  def help do
    "Responds with instructions to waiting for approval messages from Flagger."
  end

  def handle_event(
        %Message{
          app: %{name: "Flagger"},
          attachments: [%{author_name: deployment_name, text: "Canary is waiting for approval."}]
        } = event,
        %{app_url: app_url} = state
      ) do
    Bot.say(event, "Click <#{app_url}|here> to approve _rollout_ of *#{deployment_name}*.")

    state
  end

  def handle_event(
        %Message{
          app: %{name: "Flagger"},
          attachments: [
            %{author_name: deployment_name, text: "Canary promotion is waiting for approval."}
          ]
        } = event,
        %{app_url: app_url} = state
      ) do
    Bot.say(event, "Click <#{app_url}|here> to approve _promotion_ of *#{deployment_name}*.")

    state
  end

  def handle_event(_, state), do: state
end
