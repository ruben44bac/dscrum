defmodule Dscrum.UserHandler do
  alias Dscrum.Repo
  alias Dscrum.UserSchema
  alias Dscrum.AuthCommand
  alias Dscrum.UserQuery
  alias Dscrum.Guardian

  def get_user(id) do
    Repo.get(UserSchema, id)
  end

  def get_user!(id) do
    Repo.get!(UserSchema, id)
  end

  def login(%AuthCommand{} = command) do
    user = UserQuery.user_username(command.username)
      |> Repo.one

    case (user != nil) do
      true -> check_password(user, command.password)
      false -> {:error, "El usuario no existe"}
    end
  end

  def check_password(user, password) do
    case Pbkdf2.verify_pass(password, user.password) do
      true -> Guardian.encode_and_sign(user, %{}, ttl: {60, :minute})
      false -> {:error, "El usurio o la contraseña son incorrectos"}
    end
  end

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
