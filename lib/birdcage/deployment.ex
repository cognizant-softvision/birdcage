defmodule Birdcage.Deployment do
  @moduledoc """
  A Flagger Deployment.
  """

  alias Birdcage.Cache

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key false
  @derive Jason.Encoder
  embedded_schema do
    field(:key, :string)
    field(:name, :string)
    field(:namespace, :string)
    field(:phase, :string)
    field(:allow_rollout, :boolean, default: false)
    field(:allow_promotion, :boolean, default: false)
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
    |> cast(params, [:key, :name, :namespace, :phase, :allow_rollout, :allow_promotion])
    |> validate_required([:key, :name, :namespace, :phase, :allow_rollout, :allow_promotion])
    |> validate_inclusion(
      :phase,
      ~w(Initialized Waiting Progressing Promoting Finalising Succeeded Failed)
    )
  end

  @doc false
  def fetch(%{"name" => _name, "namespace" => _namespace} = params) do
    with {:ok, data} <- new(params) do
      Cache.fetch(data.key, fn -> data end)
    end
  end

  @doc false
  def update(%__MODULE__{key: key} = value) do
    Cache.set(key, value)
  end

  @doc false
  def delete(%__MODULE__{key: key}), do: Cache.delete(key)
  def delete(key), do: Cache.delete(key)

  @doc false
  def get(key), do: Cache.get(key)

  @doc false
  def get!(key), do: Cache.get!(key)

  def allow_rollout?(%__MODULE__{allow_rollout: true}), do: :ok
  def allow_rollout?(%__MODULE__{allow_rollout: false}), do: {:error, :forbidden}

  def allow_promotion?(%__MODULE__{allow_promotion: true}), do: :ok
  def allow_promotion?(%__MODULE__{allow_promotion: false}), do: {:error, :forbidden}
end
