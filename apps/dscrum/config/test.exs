# Since configuration is shared in umbrella projects, this file
# should only configure the :dscrum application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :dscrum, Dscrum.Repo,
  username: "postgres",
  password: "postgres",
  database: "dscrum_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
