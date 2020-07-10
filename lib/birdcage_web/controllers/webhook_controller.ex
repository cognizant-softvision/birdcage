defmodule BirdcageWeb.WebhookController do
  @moduledoc tags: ["webhooks"]

  use BirdcageWeb, :controller
  use OpenApiSpex.Controller
  use BirdcageWeb.ApiSpec

  alias BirdcageWeb.Schemas

  @doc """
  Confirm rollout hook.

  Hook is executed before scaling up the canary deployment and can be used for manual approval.
  The rollout is paused until the hook returns a successful HTTP status code.
  """
  @doc request_body: {"Webhook payload", "application/json", Schemas.Webhook, required: true},
       responses: [
         ok: "Approved",
         unprocessable_entity: {"Unprocessable", "application/json", Schemas.SchemaError},
         forbidden: "Forbidden"
       ]
  def rollout(conn, _params) do
    json(conn, %{})
  end
end
