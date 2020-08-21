# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :birdcage, BirdcageWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/3Of94esEkamVhSN4NSPt/9guAPCCuZAjXBrmDL+pt4DnVnbinI1YdiAmUs/MQBH",
  render_errors: [view: BirdcageWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Birdcage.PubSub,
  live_view: [signing_salt: "kzW/p2cU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Cache
config :birdcage, Birdcage.Cache,
  # => 1 hr
  gc_interval: 3_600_000,
  # => 1 day
  # gc_interval: 86_400_000,
  # backend: :shards
  backend: :ets

config :birdcage, NebulexEctoRepoAdapter, cache: Birdcage.Cache

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
