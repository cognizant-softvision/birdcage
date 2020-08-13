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
          attachments: [%{author_name: deployment_name, text: text}]
        } = event,
        state
      ) do
    app_url = Keyword.fetch!(state, :app_url)

    reply_to(event, deployment_name, app_url, text)

    state
  end

  def handle_event(_event, state), do: state

  defp reply_to(event, name, url, "Canary is waiting for approval.") do
    Bot.say(event, "Click <#{url}|here> to approve _rollout_ of *#{name}*.")
  end

  defp reply_to(event, name, url, "Canary promotion is waiting for approval.") do
    Bot.say(event, "Click <#{url}|here> to approve _promotion_ of *#{name}*.")
  end

  defp reply_to(_event, _name, _url, _), do: nil
end
