defmodule BirdcageBot.Config do
  @moduledoc false

  use Vapor.Planner

  dotenv()

  config :bot,
         env([
           {:enabled, "BOT_ENABLED", default: false, map: &String.match?(&1, ~r/true/)},
           {:slack_token, "BOT_SLACK_TOKEN", required: false},
           {:name, "BOT_NAME", default: "birdcage"},
           {:alias, "BOT_ALIAS", default: "birdcage"},
           {:app_url, "BOT_APP_URL", required: false}
         ])
end
