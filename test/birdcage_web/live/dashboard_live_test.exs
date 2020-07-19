defmodule BirdcageWeb.DashboardLiveTest do
  use BirdcageWeb.ConnCase

  import Phoenix.LiveViewTest

  @valid_params %{
    "name" => "podinfo",
    "namespace" => "test",
    "phase" => "Progressing"
  }

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
    {:ok, deployment} = Birdcage.Deployment.fetch(@valid_params)
    assert {:error, :forbidden} = Birdcage.Deployment.allow_rollout?(deployment)

    # test
    {:ok, index_live, html} = live(conn, Routes.dashboard_path(conn, :index))

    assert html =~ "border-red-400"

    assert index_live
           |> element("label[phx-click='toggle_rollout']")
           |> render_click() =~ "border-green-400"

    assert :ok =
             Birdcage.Deployment.get!(deployment.key)
             |> Birdcage.Deployment.allow_rollout?()
  end

  test "updates toggle state when promotion clicked", %{conn: conn} do
    # setup
    {:ok, deployment} = Birdcage.Deployment.fetch(@valid_params)
    assert {:error, :forbidden} = Birdcage.Deployment.allow_promotion?(deployment)

    # test
    {:ok, index_live, html} = live(conn, Routes.dashboard_path(conn, :index))

    assert html =~ "border-red-400"

    assert index_live
           |> element("label[phx-click='toggle_promotion']")
           |> render_click() =~ "border-green-400"

    assert :ok =
             Birdcage.Deployment.get!(deployment.key)
             |> Birdcage.Deployment.allow_promotion?()
  end
end
