defmodule BirdcageWeb.WebhookController do
  @moduledoc tags: ["webhooks"]

  use BirdcageWeb, :controller
  use OpenApiSpex.Controller
  use BirdcageWeb.ApiSpec

  alias BirdcageWeb.Schemas

  action_fallback BirdcageWeb.FallbackController

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
    with {:ok, deployment} <- Birdcage.Deployment.fetch(webhook_params),
         _ <- Birdcage.Deployment.touch_confirm_rollout(deployment),
         :ok <- Birdcage.Deployment.allow_rollout?(deployment) do
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
    with {:ok, deployment} <- Birdcage.Deployment.fetch(webhook_params),
         _ <- Birdcage.Deployment.touch_confirm_promotion(deployment),
         :ok <- Birdcage.Deployment.allow_promotion?(deployment) do
      conn
      |> put_status(:ok)
      |> render(:"200")
    end
  end
end
