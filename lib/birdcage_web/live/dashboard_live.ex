defmodule BirdcageWeb.DashboardLive do
  @moduledoc false

  use BirdcageWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = socket |> fetch()

    if connected?(socket), do: subscribe(socket.assigns)

    {:ok, socket}
  end

  defp fetch(socket) do
    socket
    |> assign(deployments: Birdcage.Dashboard.get_deployments())
  end

  @impl true
  def handle_event("toggle_rollout", %{"key" => key}, socket) do
    Birdcage.Dashboard.toggle_rollout(key)

    {:noreply, fetch(socket)}
  end

  def handle_event("toggle_promotion", %{"key" => key}, socket) do
    Birdcage.Dashboard.toggle_promotion(key)

    {:noreply, fetch(socket)}
  end

  @impl true
  def handle_info({Birdcage.Deployment, _action, _key, _value}, socket) do
    {:noreply, fetch(socket)}
  end

  defp subscribe(_assigns) do
    Birdcage.Deployment.subscribe()
  end
end
