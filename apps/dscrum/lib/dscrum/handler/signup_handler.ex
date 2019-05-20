defmodule Dscrum.SignupHandler do

  alias Dscrum.Repo
  alias Dscrum.UserSchema
  alias Dscrum.UserQuery

  def validate(attrs) do
    user = %UserSchema{}
      |> UserSchema.changeset(attrs)
      |> Ecto.Changeset.put_change(:password, Pbkdf2.hash_pwd_salt(Map.get(attrs, "password")))

    match = UserQuery.validate(user.params["username"], user.params["mail"])
      |> Repo.all()

    case (match == []) do
      true -> Repo.insert(user)
      false -> {:error, "El usuario ya existe"}
    end
  end

end
