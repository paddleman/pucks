# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pucks,
  ecto_repos: [Pucks.Repo],
  jwt_secret: System.get_env("JWT_SECRET") || "Av37mx6YjVtL9ZVnlu628ynHdSieRVzMW65wFDZMcQvPQfa+t9nE9bRn8TnIzmNI"


# Configures the endpoint
config :pucks, PucksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "13kynUckRww8/6G2SEtrAFuTUo3cfFL3uZooTBHHcPqYrgsmlGilSfIirtbO4Z9p",
  render_errors: [view: PucksWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Pucks.PubSub,
  live_view: [signing_salt: "97uvtAM6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason



#ja_serializer setup
config :phoenix, :format_encoders,
  "json-api": Jason

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

# geo_postgis to use Jason
config :geo_postgis,
json_library: Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
