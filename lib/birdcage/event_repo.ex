defmodule Birdcage.EventRepo do
  @moduledoc false
  use Ecto.Repo, otp_app: :birdcage, adapter: NebulexEctoRepoAdapter
end
