defmodule Dscrum.UserHandler do

  import Ecto.Query, warn: false

  alias Dscrum.Repo
  alias Dscrum.UserSchema
  alias Dscrum.AuthCommand
  alias Dscrum.UserQuery
  alias Dscrum.Guardian

  def list_user() do
    Repo.all(UserSchema)
  end

  def get_user(id) do
    Repo.get(UserSchema, id)
  end

  def get_user!(id) do

    user = Repo.get!(UserSchema, id)
    {:ok, file} = File.read(user.image)

    user
     |> Map.put(:image, Base.encode64(file))

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
      false -> {:error, "El usuario o la contraseña son incorrectos"}
    end
  end

  def validate(attrs) do
    user = %UserSchema{}
      |> UserSchema.changeset(attrs)
      |> Ecto.Changeset.put_change(:password, Pbkdf2.hash_pwd_salt(Map.get(attrs, "password")))

    match = UserQuery.validate(user.params["username"], user.params["mail"])
      |> Repo.all()

    case (match == []) do
      true -> add(user)
      false -> {:error, "El usuario ya existe"}
    end
  end

  def add(user) do
    {:ok, data} = Base.decode64(user.changes.image)
    image_path = "C:/Users/luis.moreno/Desktop/"<>user.changes.username<>".jpg"
    File.write(image_path, data, [:binary])
    user
      |> Ecto.Changeset.put_change(:image, image_path)
      |> Repo.insert
  end

end
