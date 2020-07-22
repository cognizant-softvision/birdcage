defmodule BirdcageWeb.DashboardLive do
  @moduledoc false

  alias Birdcage.Dashboard

  use BirdcageWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = socket |> fetch()

    if connected?(socket), do: subscribe(socket.assigns)

    {:ok, socket}
  end

  defp fetch(socket) do
    socket
    |> assign(deployments: Dashboard.list_deployments())
  end

  @impl true
  def handle_event("toggle_rollout", %{"id" => id}, socket) do
    Dashboard.toggle_rollout(id)

    {:noreply, fetch(socket)}
  end

  def handle_event("toggle_promotion", %{"id" => id}, socket) do
    Dashboard.toggle_promotion(id)

    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_info({Dashboard, [_schema, _action], _result}, socket) do
    {:noreply, fetch(socket)}
  end

  defp subscribe(_assigns) do
    Dashboard.subscribe()
  end
end
