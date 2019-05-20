defmodule Dscrum.UserQuery do
  import Ecto.Query
  alias Dscrum.UserSchema

  def validate(username, mail) do
    from u in UserSchema,
    where:
      u.username == ^username or u.mail == ^mail
  end

  def user_username(username) do
    from u in UserSchema,
    where:
      u.username == ^username
  end


end
