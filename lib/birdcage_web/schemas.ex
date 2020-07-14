defmodule BirdcageWeb.Schemas do
  @moduledoc """
  Defines all schemas used in the API
  """

  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule Webhook do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Webhook",
      description: "Flagger webhook payload",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Pod name"},
        namespace: %Schema{type: :string, description: "Pod namespace"},
        phase: %Schema{
          type: :string,
          enum: [
            "Initialized",
            "Waiting",
            "Progressing",
            "Promoting",
            "Finalising",
            "Succeeded",
            "Failed"
          ],
          description: "Rollout phase"
        }
      },
      required: [:name, :namespace],
      example: %{
        "name" => "podinfo",
        "namespace" => "test",
        "phase" => "Progressing"
      }
    })
  end

  defmodule SchemaError do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "SchemaError",
      description: "Schema validation error.",
      type: :object,
      properties: %{
        message: %Schema{type: :string},
        source: %Schema{type: :object},
        title: %Schema{type: :string}
      },
      required: [:message, :source, :title],
      example: %{
        "message" => "Missing field: name",
        "source" => %{"pointer" => "/webhook/name"},
        "title" => "Invalid value"
      }
    })
  end
end
