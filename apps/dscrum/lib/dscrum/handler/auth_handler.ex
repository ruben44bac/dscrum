defmodule Dscrum.AuthHandler do
  alias Dscrum.AuthCommand
  alias Dscrum.Repo
  alias Dscrum.UserQuery

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
      true -> {:ok, "Acceso autorizado"}
      false -> {:error, "El usurio o la contraseña son incorrectos"}
    end


  end
end
