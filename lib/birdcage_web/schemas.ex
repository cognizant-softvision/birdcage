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

  defmodule Event do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Event",
      description: "Flagger event payload",
      type: :object,
      allOf: [
        Webhook,
        %Schema{
          type: :object,
          properties: %{
            metadata: %Schema{
              type: :object,
              properties: %{
                eventMessage: %Schema{type: :string, description: "canary event message"},
                eventType: %Schema{type: :string, description: "canary event type"},
                timestamp: %Schema{type: :string, description: "unix timestamp ms"}
              },
              required: [:eventMessage, :eventType, :timestamp]
            }
          },
          required: [:metadata]
        }
      ],
      example: %{
        "name" => "podinfo",
        "namespace" => "test",
        "phase" => "Progressing",
        "metadata" => %{
          "eventMessage" => "string (canary event message)",
          "eventType" => "string (canary event type)",
          "timestamp" => "string (unix timestamp ms)"
        }
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
