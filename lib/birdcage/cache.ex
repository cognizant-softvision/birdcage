defmodule Birdcage.Cache do
  @moduledoc false
  use Nebulex.Cache, otp_app: :birdcage, adapter: Nebulex.Adapters.Local
end
