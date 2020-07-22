defmodule Birdcage.Repo do
  use Ecto.Repo, otp_app: :birdcage, adapter: NebulexEctoRepoAdapter
end
