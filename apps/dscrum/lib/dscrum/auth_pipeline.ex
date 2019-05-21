defmodule Dscrum.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :dscrum,
  module: Dscrum.Guardian,
  error_handler: Dscrum.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
