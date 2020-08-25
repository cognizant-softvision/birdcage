import Config

config :birdcage, BirdcageWeb.Endpoint,
  server: true,
  http: [
    transport_options: [socket_opts: [:inet6]]
  ]
