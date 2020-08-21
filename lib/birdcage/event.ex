defmodule Birdcage.Event do
  @moduledoc """
  A Flagger Event.
      %{
        "metadata" => %{
          "eventMessage" => "Canary failed! Scaling down rollout-test.flagger",
          "eventType" => "Warning",
          "timestamp" => "1597351286259"
        },
        "name" => "rollout-test",
        "namespace" => "flagger",
        "phase" => "Failed"
      }
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive Jason.Encoder
  schema("event") do
    field(:name, :string)
    field(:namespace, :string)
    field(:phase, :string)

    embeds_one :metadata, Metadata, on_replace: :delete, primary_key: false do
      field(:eventMessage, :string)
      field(:eventType, :string)
      field(:timestamp, :utc_datetime)
    end

    timestamps(type: :utc_datetime)
  end

  def changeset(params) do
    changeset(%__MODULE__{}, params)
  end

  def changeset(schema, params) do
    schema
    |> cast(params, [:name, :namespace, :phase])
    |> validate_required([:name, :namespace, :phase])
    |> validate_inclusion(
      :phase,
      ~w(Initialized Waiting Progressing Promoting Finalising Succeeded Failed)
    )
    |> cast_embed(:metadata, with: &metadata_changeset/2)
  end

  defp metadata_changeset(schema, params) do
    params = params |> convert_timestamp()

    schema
    |> cast(params, [:eventMessage, :eventType, :timestamp])
    |> validate_required([:eventMessage, :eventType, :timestamp])
  end

  def convert_timestamp(%{"timestamp" => ts} = params) when is_binary(ts) do
    converted_params =
      Map.update!(params, "timestamp", fn current_value ->
        with {int_value, _} <- Integer.parse(current_value),
             {:ok, timestamp} <- DateTime.from_unix(int_value, :millisecond) do
          timestamp
        else
          _ ->
            current_value
        end
      end)

    converted_params
  end

  def convert_timestamp(params), do: params
end
