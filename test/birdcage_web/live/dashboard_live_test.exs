defmodule BirdcageWeb.DashboardLiveTest do
  use BirdcageWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Birdcage.Dashboard

  @valid_params %{
    "name" => "podinfo",
    "namespace" => "test",
    "phase" => "Progressing"
  }

  setup %{conn: conn} do
    # fake authentication
    conn =
      conn
      |> Plug.Test.init_test_session(user_name: "tester")

    {:ok, conn: conn}
  end

  setup do
    # clear the cache before each test
    Birdcage.Cache.stream()
    |> Enum.each(&Birdcage.Cache.delete(&1))
  end

  test "disconnected and connected render", %{conn: conn} do
    {:ok, index_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Deployments"
    assert render(index_live) =~ "Deployments"
  end

  test "updates toggle state when rollout clicked", %{conn: conn} do
    # setup
    {:ok, deployment} = Dashboard.fetch_deployment(@valid_params)
    assert {:error, :forbidden} = Dashboard.allow_rollout?(deployment)

    # test
    {:ok, index_live, html} = live(conn, Routes.dashboard_path(conn, :index))

    assert html =~ "border-red-400"

    assert index_live
           |> element("label[phx-click='toggle_rollout']")
           |> render_click() =~ "border-green-400"

    assert :ok =
             Dashboard.get_deployment!(deployment.id)
             |> Dashboard.allow_rollout?()
  end

  test "updates toggle state when promotion clicked", %{conn: conn} do
    # setup
    {:ok, deployment} = Dashboard.fetch_deployment(@valid_params)
    assert {:error, :forbidden} = Dashboard.allow_promotion?(deployment)

    # test
    {:ok, index_live, html} = live(conn, Routes.dashboard_path(conn, :index))

    assert html =~ "border-red-400"

    assert index_live
           |> element("label[phx-click='toggle_promotion']")
           |> render_click() =~ "border-green-400"

    assert :ok =
             Dashboard.get_deployment!(deployment.id)
             |> Dashboard.allow_promotion?()
  end
end
