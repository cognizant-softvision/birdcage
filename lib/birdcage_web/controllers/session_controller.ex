defmodule BirdcageWeb.SessionController do
  use BirdcageWeb, :controller

  action_fallback BirdcageWeb.FallbackController

  def authenticate(conn, _params) do
    conn
    |> redirect(external: OpenIDConnect.authorization_uri(:birdcage))
  end

  def callback(conn, %{"code" => code}) do
    with {:ok, tokens} <- OpenIDConnect.fetch_tokens(:birdcage, %{code: code}),
         {:ok, claims} <- OpenIDConnect.verify(:birdcage, tokens["id_token"]),
         {:ok, access_token} <- OpenIDConnect.verify(:birdcage, tokens["access_token"]),
         {:ok, :authorized} <- verify_access(access_token) do
      user_name = claims["name"]

      conn
      |> put_session(:user_name, user_name)
      |> redirect(to: "/")
    end
  end

  def logout(conn, _params) do
    conn
    |> clear_session
    |> redirect(to: "/")
  end

  defp verify_access(access_token) do
    if client_role() in get_in(access_token, ["resource_access", client_id(), "roles"]) do
      {:ok, :authorized}
    else
      {:error, :unauthorized}
    end
  end

  defp client_id, do: get_in(Birdcage.Application.config(), [:openid_connect, :client_id])
  defp client_role, do: get_in(Birdcage.Application.config(), [:openid_connect, :client_role])
end
