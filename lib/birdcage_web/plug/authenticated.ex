defmodule BirdcageWeb.Plugs.Authenticated do
  @moduledoc """
  Verify user is authenticated.
  """

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), list()) :: no_return()
  def call(conn, opts \\ [])

  def call(conn, _opts) do
    case authenticated?(conn) do
      true -> conn
      _ -> halt_with(401, conn)
    end
  end

  defp authenticated?(conn) do
    not Birdcage.Application.authentication_enabled?() ||
      Plug.Conn.get_session(conn, :user_name) != nil
  end

  defp halt_with(code, conn) do
    conn
    |> Plug.Conn.put_status(code)
    |> Phoenix.Controller.put_view(BirdcageWeb.ErrorView)
    |> Phoenix.Controller.put_layout({BirdcageWeb.LayoutView, :app})
    |> Phoenix.Controller.render(:"#{code}")
    |> Plug.Conn.halt()
  end
end
