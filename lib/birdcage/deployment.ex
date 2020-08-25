defmodule Birdcage.Deployment do
  @moduledoc """
  A Flagger Deployment.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive Jason.Encoder
  schema "deployments" do
    field(:allow_promotion, :boolean, default: false)
    field(:allow_rollout, :boolean, default: false)
    field(:confirm_promotion_at, :utc_datetime)
    field(:confirm_rollout_at, :utc_datetime)
    field(:name, :string)
    field(:namespace, :string)
    field(:phase, :string)

    timestamps(type: :utc_datetime)
  end

  def changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(deployment, attrs) do
    deployment
    |> cast(attrs, [
      :name,
      :namespace,
      :phase,
      :allow_rollout,
      :allow_promotion,
      :confirm_rollout_at,
      :confirm_promotion_at
    ])
    |> validate_required([
      :name,
      :namespace,
      :phase,
      :allow_rollout,
      :allow_promotion
    ])
    |> validate_inclusion(
      :phase,
      ~w(Initialized Waiting Progressing Promoting Finalising Succeeded Failed)
    )
    |> unique_constraint([:name, :namespace])
  end
end
