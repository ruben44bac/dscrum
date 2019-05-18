# Since configuration is shared in umbrella projects, this file
# should only configure the :dscrum_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :dscrum_web,
  ecto_repos: [Dscrum.Repo],
  generators: [context_app: :dscrum]

# Configures the endpoint
config :dscrum_web, DscrumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wzp1RkaXVz4JGoEDhmlrPULDHDR7YfnikuInAl6VVmOvgoN8tEfYFbohcHd8ff00",
  render_errors: [view: DscrumWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: DscrumWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
