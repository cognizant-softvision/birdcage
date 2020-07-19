defmodule Birdcage.Deployment do
  @moduledoc """
  A Flagger Deployment.
  """

  alias Birdcage.Cache

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @topic inspect(__MODULE__)

  @primary_key false
  @derive Jason.Encoder
  embedded_schema do
    field(:key, :string)
    field(:name, :string)
    field(:namespace, :string)
    field(:phase, :string)
    field(:allow_rollout, :boolean, default: false)
    field(:allow_promotion, :boolean, default: false)
    field(:confirm_rollout_at, :utc_datetime)
    field(:confirm_promotion_at, :utc_datetime)
  end

  @doc false
  def new(%{"name" => name, "namespace" => namespace} = params) do
    params = Map.put(params, "key", "#{name}.#{namespace}")

    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:update)
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [
      :key,
      :name,
      :namespace,
      :phase,
      :allow_rollout,
      :allow_promotion,
      :confirm_rollout_at,
      :confirm_promotion_at
    ])
    |> validate_required([:key, :name, :namespace, :phase, :allow_rollout, :allow_promotion])
    |> validate_inclusion(
      :phase,
      ~w(Initialized Waiting Progressing Promoting Finalising Succeeded Failed)
    )
  end

  @doc """
  Get cached value for key or set value by evaluating `fun`.
  """
  def fetch(%{"name" => _name, "namespace" => _namespace} = params) do
    with {:ok, data} <- new(params) do
      fetch(data.key, fn -> data end)
    end
  end

  defp fetch(key, fun, opts \\ []) do
    {:ok,
     case Cache.get(key, opts) do
       nil -> set(key, fun.(), opts)
       result -> result
     end}
  end

  @doc """
  Set the given `value` under `key` into the Cache.
  """
  def set(%__MODULE__{key: key} = value, opts \\ []), do: set(key, value, opts)

  def set(key, value, opts) do
    with :ok <- Cache.put(key, value, opts) do
      broadcast(:set, key, value)
      value
    end
  end

  @doc false
  def delete(%__MODULE__{key: key}), do: delete(key)

  def delete(key) do
    with :ok = value <- Cache.delete(key) do
      broadcast(:delete, key, value)
      value
    end
  end

  @doc false
  defdelegate get(key, opts \\ []), to: Cache
  defdelegate get!(key, opts \\ []), to: Cache

  @doc """
  Update the last confirm rollout timestamp
  """
  def touch_confirm_rollout(%__MODULE__{} = data) do
    set(%__MODULE__{data | confirm_rollout_at: DateTime.utc_now()})
  end

  @doc """
  Update the last confirm promotion timestamp
  """
  def touch_confirm_promotion(%__MODULE__{} = data) do
    set(%__MODULE__{data | confirm_promotion_at: DateTime.utc_now()})
  end

  def allow_rollout?(%__MODULE__{allow_rollout: true}), do: :ok
  def allow_rollout?(%__MODULE__{allow_rollout: false}), do: {:error, :forbidden}

  def allow_promotion?(%__MODULE__{allow_promotion: true}), do: :ok
  def allow_promotion?(%__MODULE__{allow_promotion: false}), do: {:error, :forbidden}

  def subscribe do
    Phoenix.PubSub.subscribe(Birdcage.PubSub, @topic)
  end

  def subscribe(key) do
    Phoenix.PubSub.subscribe(Birdcage.PubSub, @topic <> "#{key}")
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
