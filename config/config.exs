# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :volt,
  ecto_repos: [Volt.Repo]

# Configures the endpoint
config :volt, Volt.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qZyyGODp8xuUV8FIEFEiJXNyl14I9JzwNZCxSXzepPRVjpmS7OlV7HVn7yoHoNpd",
  render_errors: [view: Volt.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Volt.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
