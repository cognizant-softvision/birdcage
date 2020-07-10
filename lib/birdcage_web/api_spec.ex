defmodule BirdcageWeb.ApiSpec do
  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  alias BirdcageWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: to_string(Application.spec(:birdcage, :description)),
        version: to_string(Application.spec(:birdcage, :vsn))
      },
      # Populate the paths from a phoenix router
      paths: Paths.from_router(Router)
    }
    # Discover request/response schemas from path specs
    |> OpenApiSpex.resolve_schema_modules()
  end

  defmacro __using__(_opts \\ []) do
    quote do
      # plug OpenApiSpex.Plug.CastAndValidate
      plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

      # See https://github.com/open-api-spex/open_api_spex/issues/92
      def action(conn, _), do: BirdcageWeb.ApiSpec.__action__(__MODULE__, conn)
      defoverridable action: 2
    end
  end

  # https://dockyard.com/blog/2016/05/02/phoenix-tips-and-tricks
  def __action__(controller, conn) do
    name = Phoenix.Controller.action_name(conn)

    if function_exported?(controller, name, 3) do
      apply(controller, name, [conn, conn.params, to_map(conn.body_params)])
    else
      apply(controller, name, [conn, conn.params])
    end
  end

  # use encode / decode to deeply cast the OpenApi Schema structs to maps
  defp to_map(params) do
    params
    |> Jason.encode!()
    |> Jason.decode!()
  end
end
