# Since configuration is shared in umbrella projects, this file
# should only configure the :dscrum application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :dscrum,
  ecto_repos: [Dscrum.Repo]

import_config "#{Mix.env()}.exs"