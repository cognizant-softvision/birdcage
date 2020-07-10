defmodule Birdcage.Cache do
  @moduledoc false

  @topic inspect(__MODULE__)

  use Nebulex.Cache,
    otp_app: :birdcage,
    adapter: Nebulex.Adapters.Local

  @doc """
  Get cached value for key or set value by evaluating `fun`.
  """
  def fetch(key, fun, opts \\ []) do
    {:ok,
     case get(key, opts) do
       nil -> set(key, fun.(), opts)
       result -> result
     end}
  end

  @doc """
  Sets the given `value` under `key` into the Cache.
  """
  def set(key, value, opts \\ []) do
    with :ok <- put(key, value, opts) do
      value
    end
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Birdcage.PubSub, @topic)
  end

  def subscribe(key) do
    Phoenix.PubSub.subscribe(Birdcage.PubSub, @topic <> "#{key}")
  end

  def post_hooks do
    {:async, [&post_hook/2]}
  end

  def post_hook(result, {_, :set, [key, _result, _opt]} = _call) do
    broadcast(:set, key, result)
  end

  def post_hook(_, _) do
    :noop
  end

  defp broadcast(event, key, result) do
    Phoenix.PubSub.broadcast(Birdcage.PubSub, @topic, {__MODULE__, event, key, result})

    Phoenix.PubSub.broadcast(
      Birdcage.PubSub,
      @topic <> "#{key}",
      {__MODULE__, event, key, result}
    )
  end
end
