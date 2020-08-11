defmodule Birdcage.Config do
  @moduledoc false

  use Vapor.Planner

  dotenv()

  config :app,
         env([
           {:url, "APP_URL"}
         ])

  config :openid_connect,
         env([
           {:enabled, "OIDC_ENABLED", default: false, map: &String.match?(&1, ~r/true/)},
           {:discovery_document_uri, "OIDC_DISCOVERY_DOCUMENT_URI", required: false},
           {:client_id, "OIDC_CLIENT_ID", required: false},
           {:client_secret, "OIDC_CLIENT_SECRET", required: false},
           {:client_role, "OIDC_CLIENT_ROLE", default: "user"},
           {:redirect_uri, "OIDC_REDIRECT_URI", required: false},
           {:response_type, "OIDC_RESPONSE_TYPE", default: "code"},
           {:scope, "OIDC_SCOPE", default: "openid"}
         ])
end
