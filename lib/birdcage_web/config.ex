defmodule BirdcageWeb.Config do
  @moduledoc false

  use Vapor.Planner

  dotenv()

  config :web,
         env([
           {:port, "PORT", default: "4000", map: &String.to_integer/1},
           {:secret_key_base, "SECRET_KEY_BASE"}
         ])
end
