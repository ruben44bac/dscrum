defmodule Dscrum.Repo do
  use Ecto.Repo,
    otp_app: :dscrum,
    adapter: Ecto.Adapters.Postgres
end
