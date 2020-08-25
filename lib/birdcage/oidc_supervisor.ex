defmodule Birdcage.OIDCSupervisor do
  @moduledoc false

  use GenServer

  require Logger

  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    case Birdcage.Application.authentication_enabled?() do
      true ->
        Logger.info("Birdcage OpenID Connect authentication enabled.")

        state = try_to_start_worker(nil)

        {:ok, state}

      _ ->
        Logger.info("Birdcage OpenID Connect authentication disabled.")

        :ignore
    end
  end

  @impl true
  def handle_info(msg, state)

  def handle_info({:DOWN, _ref, :process, object, reason}, state) do
    {worker_pid, _} = state

    if object === worker_pid do
      Logger.error("OpenID Connect worker failed; reason: #{inspect(reason)}")
      delay_ms = next_delay_ms(nil)
      Process.send_after(self(), :try_to_start_worker, delay_ms)
      {:noreply, build_state(nil, delay_ms)}
    else
      Logger.info("Down signal received NOT matching the OpenID Connect worker process")
      {:noreply, state}
    end
  end

  def handle_info(:try_to_start_worker, state) do
    {_, previous_delay_ms} = state
    state = try_to_start_worker(previous_delay_ms)
    {:noreply, state}
  end

  defp openid_config do
    config = Birdcage.Application.config()

    [birdcage: Map.to_list(config.openid_connect)]
  end

  defp build_state(worker_pid, delay_ms) do
    {worker_pid, delay_ms}
  end

  defp try_to_start_worker(previous_delay_ms) do
    Logger.info("Starting OpenID Connect worker ...")

    case GenServer.start(OpenIDConnect.Worker, openid_config(), name: :openid_connect) do
      {:ok, worker_pid} ->
        Logger.info("OpenID Connect worker started")
        Process.monitor(worker_pid)
        build_state(worker_pid, nil)

      {:error, reason} ->
        Logger.error("OpenID Connect worker failed to start; reason: #{inspect(reason)}")
        delay_ms = next_delay_ms(previous_delay_ms)
        Process.send_after(self(), :try_to_start_worker, delay_ms)
        build_state(nil, delay_ms)

      error ->
        Logger.error("OpenID Connect error: #{inspect(error)}")
        delay_ms = next_delay_ms(previous_delay_ms)
        build_state(nil, delay_ms)
    end
  end

  defp next_delay_ms(nil), do: 225_000

  defp next_delay_ms(previous_delay_ms) when previous_delay_ms >= 3_600_000, do: 3_600_000

  defp next_delay_ms(previous_delay_ms) do
    previous_delay_ms * 2
  end
end
