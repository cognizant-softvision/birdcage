defmodule BirdcageWeb.RequireLoginTest do
  @moduledoc false
  use BirdcageWeb.ConnCase

  alias BirdcageWeb.Plugs.RequireLogin

  setup %{conn: conn} do
    conn =
      conn
      |> Plug.Test.init_test_session(%{})
      |> Plug.Conn.fetch_session()

    {:ok, conn: conn}
  end

  describe "authentication enabled" do
    setup do
      System.put_env("OIDC_ENABLED", "true")
    end

    test "user is redirected when user_name is not set", %{conn: conn} do
      conn = conn |> require_login

      assert redirected_to(conn) == Routes.session_path(conn, :authenticate)
    end

    test "user passes through when user_name is set", %{conn: conn} do
      conn = conn |> authenticate |> require_login

      assert not_redirected?(conn)
    end
  end

  describe "authentication disabled" do
    setup do
      System.put_env("OIDC_ENABLED", "false")
    end

    test "user passes through when user_name is not set", %{conn: conn} do
      conn = conn |> require_login

      assert not_redirected?(conn)
    end
  end

  defp require_login(conn) do
    conn |> RequireLogin.call(%{})
  end

  defp authenticate(conn) do
    conn |> Plug.Test.init_test_session(user_name: "tester")
  end

  defp not_redirected?(conn) do
    conn.status != 302
  end
end
