defmodule Birdcage.Deployment do
  @moduledoc """
  A Flagger Deployment.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  # @primary_key false
  @primary_key {:id, :string, autogenerate: false}
  @derive Jason.Encoder
  schema("deployment") do
    field(:name, :string)
    field(:namespace, :string)
    field(:phase, :string)
    field(:allow_rollout, :boolean, default: false)
    field(:allow_promotion, :boolean, default: false)
    field(:confirm_rollout_at, :utc_datetime)
    field(:confirm_promotion_at, :utc_datetime)
  end

  def changeset(%{"name" => name, "namespace" => namespace} = params) do
    params = Map.put(params, "id", "#{name}.#{namespace}")

    changeset(%__MODULE__{}, params)
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [
      :id,
      :name,
      :namespace,
      :phase,
      :allow_rollout,
      :allow_promotion,
      :confirm_rollout_at,
      :confirm_promotion_at
    ])
    |> validate_required([:id, :name, :namespace, :phase, :allow_rollout, :allow_promotion])
    |> validate_inclusion(
      :phase,
      ~w(Initialized Waiting Progressing Promoting Finalising Succeeded Failed)
    )
  end
end
