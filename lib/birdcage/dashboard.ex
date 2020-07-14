defmodule Birdcage.Dashboard do
  @moduledoc """
  A Flagger Dashboard.
  """

  alias Birdcage.{Cache, Deployment}

  def get_deployments do
    Cache.all(:unexpired, return: :value)
  end

  def toggle_rollout(key) do
    Deployment.get!(key)
    |> Map.get_and_update!(:allow_rollout, fn value -> {value, not value} end)
    |> elem(1)
    |> Deployment.set()
  end

  def toggle_promotion(key) do
    Deployment.get!(key)
    |> Map.get_and_update!(:allow_promotion, fn value -> {value, not value} end)
    |> elem(1)
    |> Deployment.set()
  end
end
