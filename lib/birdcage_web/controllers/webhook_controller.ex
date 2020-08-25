defmodule BirdcageWeb.WebhookController do
  @moduledoc tags: ["webhooks"]

  require Logger

  use BirdcageWeb, :controller
  use OpenApiSpex.Controller
  use BirdcageWeb.ApiSpec

  alias Birdcage.{Dashboard, Deployment}
  alias BirdcageWeb.Schemas

  action_fallback(BirdcageWeb.FallbackController)

  @event_ttl 3_600_000

  @doc """
  Confirm rollout webhook.

  Hook is executed before scaling up the canary deployment and can be used for manual approval.
  The rollout is paused until the hook returns a successful HTTP status code.
  """
  @doc request_body: {"Webhook payload", "application/json", Schemas.Webhook, required: true},
       responses: [
         ok: "Approved",
         unprocessable_entity: {"Unprocessable", "application/json", Schemas.SchemaError},
         forbidden: "Forbidden"
       ]
  def confirm_rollout(conn, _params, webhook_params) do
    with {:ok, %Deployment{} = deployment} <- Dashboard.fetch_deployment(webhook_params),
         _ <- Dashboard.touch_confirm_rollout(deployment),
         :ok <- Dashboard.allow_rollout?(deployment) do
      conn
      |> put_status(:ok)
      |> render(:"200")
    end
  end

  @doc """
  Confirm promotion webhook.

  Hook is executed before scaling up the canary deployment and can be used for manual approval.
  The promotion is paused until the hook returns a successful HTTP status code.
  """
  @doc request_body: {"Webhook payload", "application/json", Schemas.Webhook, required: true},
       responses: [
         ok: "Approved",
         unprocessable_entity: {"Unprocessable", "application/json", Schemas.SchemaError},
         forbidden: "Forbidden"
       ]
  def confirm_promotion(conn, _params, webhook_params) do
    with {:ok, %Deployment{} = deployment} <- Dashboard.fetch_deployment(webhook_params),
         _ <- Dashboard.touch_confirm_promotion(deployment),
         :ok <- Dashboard.allow_promotion?(deployment) do
      conn
      |> put_status(:ok)
      |> render(:"200")
    end
  end

  @doc """
  Event webhook.

  Hook executed every time Flagger emits a Kubernetes event.
  When configured, every action that Flagger takes during a canary deployment
  will be sent as JSON via an HTTP POST request.
  """
  @doc request_body: {"Event payload", "application/json", Schemas.Event, required: true},
       responses: [
         ok: "Approved",
         unprocessable_entity: {"Unprocessable", "application/json", Schemas.SchemaError}
       ]
  def event(conn, _params, event_params) do
    with {:ok, _event} <- Dashboard.create_event(event_params, ttl: @event_ttl) do
      conn
      |> put_status(:ok)
      |> render(:"200")
    end
  end
end
