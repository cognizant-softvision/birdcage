defmodule BirdcageWeb.WebhookControllerTest do
  @moduledoc false
  use BirdcageWeb.ConnCase
  import OpenApiSpex.TestAssertions

  alias Birdcage.Deployment

  test "Webhook example matches schema" do
    api_spec = BirdcageWeb.ApiSpec.spec()
    schema = BirdcageWeb.Schemas.Webhook.schema()
    assert_schema(schema.example, "Webhook", api_spec)
  end

  describe "Confirm Rollout Webhook" do
    setup %{conn: conn} do
      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("content-type", "application/json")

      {:ok, conn: conn}
    end

    @valid_params %{
      "name" => "podinfo",
      "namespace" => "test",
      "phase" => "Progressing"
    }

    @invalid_params %{
      "name" => nil,
      "namespace" => 1234,
      "phase" => "BAD"
    }

    test "renders forbidden when rollout is NOT allowed", %{conn: conn} do
      conn = post(conn, Routes.webhook_path(conn, :confirm_rollout), @valid_params)
      assert "Forbidden" = json_response(conn, 403)
    end

    test "renders success when rollout is allowed", %{conn: conn} do
      # setup
      {:ok, deployment} = Deployment.fetch(@valid_params)
      assert {:error, :forbidden} = Deployment.allow_rollout?(deployment)

      deployment = Deployment.update(%Deployment{deployment | allow_rollout: true})
      assert :ok = Deployment.allow_rollout?(deployment)

      # test
      conn = post(conn, Routes.webhook_path(conn, :confirm_rollout), @valid_params)
      assert body = json_response(conn, 200)

      # cleanup
      Deployment.delete(deployment)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.webhook_path(conn, :confirm_rollout), @invalid_params)
        |> json_response(422)

      assert %{"errors" => _} = response
    end
  end
end
