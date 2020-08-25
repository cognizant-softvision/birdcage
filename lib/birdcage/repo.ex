defmodule Birdcage.Repo do
  use Ecto.Repo, otp_app: :birdcage, adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    app_config = Vapor.load!(Birdcage.Config)

    {:ok,
     config
     |> Keyword.put(:url, app_config.db.url)
     |> Keyword.put(:pool_size, app_config.db.pool_size)}
  end
end
