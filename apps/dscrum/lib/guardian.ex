defmodule Dscrum.Guardian do
  use Guardian, otp_app: :dscrum

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Dscrum.UserHandler.get_user!(id)
    {:ok,  resource}
  end
end
