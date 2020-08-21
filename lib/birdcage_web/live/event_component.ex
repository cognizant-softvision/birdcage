defmodule EventComponent do
  @moduledoc false

  use BirdcageWeb, :live_component

  def deployment_name(event) do
    "#{event.name}.#{event.namespace}"
  end

  def message(event) do
    event.metadata.eventMessage
  end

  def phase_class_bg("Initialized"), do: "bg-yellow-400"
  def phase_class_bg("Waiting"), do: "bg-orange-400"
  def phase_class_bg("Progressing"), do: "bg-green-400"
  def phase_class_bg("Promoting"), do: "bg-teal-400"
  def phase_class_bg("Finalising"), do: "bg-indigo-400"
  def phase_class_bg("Succeeded"), do: "bg-purple-400"
  def phase_class_bg("Failed"), do: "bg-red-400"
  def phase_class_bg(_phase), do: "bg-gray-200"
end
