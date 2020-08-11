defmodule BirdcageWeb.SessionController do
  use BirdcageWeb, :controller

  action_fallback BirdcageWeb.FallbackController

  @client_id get_in(Birdcage.Application.config(), [:openid_connect, :client_id])
  @client_role get_in(Birdcage.Application.config(), [:openid_connect, :client_role])

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

  defp verify_access(%{
         "resource_access" => %{
           @client_id => %{
             "roles" => [@client_role]
           }
         }
       }) do
    {:ok, :authorized}
  end

  defp verify_access(_access_token), do: {:error, :unauthorized}
end
