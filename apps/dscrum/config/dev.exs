# Since configuration is shared in umbrella projects, this file
# should only configure the :dscrum application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :dscrum, Dscrum.Repo,
  username: "postgres",
  password: "",
  database: "dscrum_dev",
  hostname: "localhost",
  pool_size: 10
