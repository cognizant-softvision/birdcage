defmodule BirdcageWeb.DashboardLive do
  @moduledoc false

  alias Birdcage.Dashboard

  use BirdcageWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> fetch_deployments()
      |> fetch_events()

    if connected?(socket), do: subscribe(socket.assigns)

    {:ok, socket, temporary_assigns: [events: []]}
  end

  defp fetch_deployments(socket) do
    socket
    |> assign(deployments: Dashboard.list_deployments())
  end

  defp fetch_events(socket) do
    socket
    |> assign(events: Dashboard.list_events())
  end

  @impl true
  def handle_event("toggle_rollout", %{"id" => id}, socket) do
    Dashboard.toggle_rollout(id)

    {:noreply, fetch_deployments(socket)}
  end

  def handle_event("toggle_promotion", %{"id" => id}, socket) do
    Dashboard.toggle_promotion(id)

    {:noreply, fetch_deployments(socket)}
  end

  @impl true
  def handle_info({Dashboard, [:deployment, _action], _result}, socket) do
    {:noreply, fetch_deployments(socket)}
  end

  def handle_info({Dashboard, [:event, :created], result}, socket) do
    {:noreply, assign(socket, :events, [result])}
  end

  defp subscribe(_assigns) do
    Dashboard.subscribe()
  end
end
