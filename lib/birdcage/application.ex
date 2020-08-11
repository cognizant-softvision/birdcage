defmodule Birdcage.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the repository
      Birdcage.Repo,
      # Start the Telemetry supervisor
      BirdcageWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Birdcage.PubSub},
      # Start the Endpoint (http/https)
      BirdcageWeb.Endpoint,
      Birdcage.OIDCSupervisor,
      BirdcageBot.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Birdcage.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BirdcageWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  def config do
    Vapor.load!(Birdcage.Config)
  end

  def authentication_enabled?, do: get_in(config(), [:openid_connect, :enabled])
end
