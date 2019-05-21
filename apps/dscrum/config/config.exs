# Since configuration is shared in umbrella projects, this file
# should only configure the :dscrum application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :dscrum,
  ecto_repos: [Dscrum.Repo]

import_config "#{Mix.env()}.exs"

config :dscrum, Dscrum.Guardian,
       issuer: "dscrum",
       secret_key: "/Iucv/EHJJCBXZ89L4Z24Lffmingww8PXBTXT7C1fU1nSXwkzhVUddzBE7jcUEWJ"
