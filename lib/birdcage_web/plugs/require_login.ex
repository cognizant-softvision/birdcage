defmodule BirdcageWeb.Plugs.RequireLogin do
  @moduledoc """
  Verify user is authenticated.
  """

  alias BirdcageWeb.Router.Helpers, as: Routes

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), list()) :: no_return()
  def call(conn, opts \\ [])

  def call(conn, _opts) do
    if disabled?() || authenticated?(conn) do
      conn
    else
      conn |> redirect_to_login
    end
  end

  defp disabled?() do
    not Birdcage.Application.authentication_enabled?()
  end

  defp authenticated?(conn) do
    Plug.Conn.get_session(conn, :user_name)
  end

  defp redirect_to_login(conn) do
    conn
    |> Phoenix.Controller.redirect(to: Routes.session_path(conn, :authenticate))
    |> Plug.Conn.halt()
  end
end
