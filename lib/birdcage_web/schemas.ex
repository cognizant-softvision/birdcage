defmodule BirdcageWeb.Schemas do
  @moduledoc """
  Defines all schemas used in the API
  """

  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule WebhookMetadata do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "WebhookMetadata",
      description: "Flagger webhook payload metadata",
      type: :object,
      properties: %{
        test: %Schema{type: :string},
        token: %Schema{type: :string}
      }
    })
  end

  defmodule Webhook do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Webhook",
      description: "Flagger webhook payload",
      type: :object,
      properties: %{
        name: %Schema{type: :string, description: "Pod name"},
        namespace: %Schema{type: :string, description: "Pod namespace"},
        phase: %Schema{type: :string, description: "Rollout phase"},
        metadata: WebhookMetadata
      },
      required: [:name, :namespace],
      example: %{
        "name" => "podinfo",
        "namespace" => "test",
        "phase" => "Progressing",
        "metadata" => %{
          "test" => "all",
          "token" => "16688eb5e9f289f1991c"
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

  defmodule ErrorResponse do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "ErrorResponse",
      description: "Error responses from the API.",
      type: :object,
      oneOf: [
        Error,
        %Schema{
          type: :object,
          properties: %{
            errors: %Schema{
              type: :array,
              items: SchemaError,
              description: "List of schema errors."
            }
          },
          required: [:errors]
        }
      ]
    })
  end
end
