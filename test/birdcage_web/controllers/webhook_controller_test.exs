defmodule BirdcageWeb.WebhookControllerTest do
  @moduledoc false
  use BirdcageWeb.ConnCase
  import OpenApiSpex.TestAssertions

  alias Birdcage.{Dashboard, Deployment}
  alias BirdcageWeb.{ApiSpec, Schemas}

  @valid_params %{
    "name" => "mypod",
    "namespace" => "dev",
    "phase" => "Progressing"
  }

  @invalid_params %{
    "name" => nil,
    "namespace" => 1234,
    "phase" => "BAD"
  }

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("content-type", "application/json")

    {:ok, conn: conn}
  end

  setup do
    # clear the cache before each test
    Birdcage.Cache.stream()
    |> Enum.each(&Birdcage.Cache.delete(&1))
  end

  test "webhook example matches schema" do
    api_spec = ApiSpec.spec()
    schema = Schemas.Webhook.schema()
    assert_schema(schema.example, "Webhook", api_spec)
  end

  describe "confirm rollout webhook" do
    test "renders forbidden when rollout is NOT allowed", %{conn: conn} do
      conn = post(conn, Routes.webhook_path(conn, :confirm_rollout), @valid_params)
      assert "Forbidden" = json_response(conn, 403)
    end

    test "renders success when rollout is allowed", %{conn: conn} do
      # setup
      {:ok, deployment} = Deployment.fetch(@valid_params)
      assert {:error, :forbidden} = Deployment.allow_rollout?(deployment)

      deployment = Dashboard.toggle_rollout(deployment.key)
      assert :ok = Deployment.allow_rollout?(deployment)

      # test
      conn = post(conn, Routes.webhook_path(conn, :confirm_rollout), @valid_params)
      assert body = json_response(conn, 200)

      latest_deployment = Birdcage.Deployment.get!(deployment.key)

      assert nil != latest_deployment.confirm_rollout_at
    end

    test "renders errors when data is invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.webhook_path(conn, :confirm_rollout), @invalid_params)
        |> json_response(422)

      assert %{"errors" => _} = response
    end
  end

  describe "confirm promotion webhook" do
    test "renders forbidden when promotion is NOT allowed", %{conn: conn} do
      conn = post(conn, Routes.webhook_path(conn, :confirm_promotion), @valid_params)
      assert "Forbidden" = json_response(conn, 403)
    end

    test "renders success when promotion is allowed", %{conn: conn} do
      # setup
      {:ok, deployment} = Deployment.fetch(@valid_params)
      assert {:error, :forbidden} = Deployment.allow_promotion?(deployment)

      deployment = Dashboard.toggle_promotion(deployment.key)
      assert :ok = Deployment.allow_promotion?(deployment)

      # test
      conn = post(conn, Routes.webhook_path(conn, :confirm_promotion), @valid_params)
      assert body = json_response(conn, 200)

      latest_deployment = Birdcage.Deployment.get!(deployment.key)

      assert nil != latest_deployment.confirm_promotion_at
    end

    test "renders errors when data is invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.webhook_path(conn, :confirm_promotion), @invalid_params)
        |> json_response(422)

      assert %{"errors" => _} = response
    end
  end
end
