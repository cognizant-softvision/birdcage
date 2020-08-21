defmodule EventComponent do
  @moduledoc false

  use BirdcageWeb, :live_component

  def deployment_name(event) do
    "#{event.name}.#{event.namespace}"
  end

  def message(event) do
    event.metadata.eventMessage
  end

  # https://github.com/weaveworks/flagger/blob/8a5a0538fd5247f52bf404950c48ecde5f7177e4/pkg/apis/flagger/v1beta1/status.go#L38
  def phase_class_bg(%{phase: "Initializing"}), do: "bg-purple-400"
  def phase_class_bg(%{phase: "Initialized"}), do: "bg-purple-400"
  def phase_class_bg(%{phase: "Waiting"}), do: "bg-orange-400"
  def phase_class_bg(%{phase: "Progressing"}), do: "bg-yellow-400"
  def phase_class_bg(%{phase: "Promoting"}), do: "bg-teal-400"
  def phase_class_bg(%{phase: "Finalising"}), do: "bg-indigo-400"
  def phase_class_bg(%{phase: "Succeeded"}), do: "bg-green-400"
  def phase_class_bg(%{phase: "Failed"}), do: "bg-red-400"
  def phase_class_bg(%{phase: "Terminating"}), do: "bg-red-400"
  def phase_class_bg(%{phase: "Terminated"}), do: "bg-red-400"
  def phase_class_bg(_event), do: "bg-gray-200"

  def type_class_bg(%{metadata: %{eventType: "Normal"}}), do: "bg-white"
  def type_class_bg(%{metadata: %{eventType: "Warning"}}), do: "bg-red-200"
  def type_class_bg(%{metadata: %{eventType: "Error"}}), do: "bg-red-400"
  def type_class_bg(_event), do: "bg-white"
end
