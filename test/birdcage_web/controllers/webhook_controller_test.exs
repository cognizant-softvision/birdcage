defmodule BirdcageWeb.WebhookControllerTest do
  @moduledoc false
  use ExUnit.Case
  import OpenApiSpex.TestAssertions

  test "Webhook example matches schema" do
    api_spec = BirdcageWeb.ApiSpec.spec()
    schema = BirdcageWeb.Schemas.Webhook.schema()
    assert_schema(schema.example, "Webhook", api_spec)
  end
end
