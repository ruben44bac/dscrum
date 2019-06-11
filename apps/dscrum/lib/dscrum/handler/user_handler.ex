defmodule Dscrum.UserHandler do
  alias Dscrum.Repo
  alias Dscrum.UserSchema
  alias Dscrum.AuthCommand
  alias Dscrum.{
    UserQuery,
    TeamSchema,
    StoryQuery
  }
  alias Dscrum.Guardian
  alias Dscrum.DashboardStruct

  def get_user(id) do
    Repo.get(UserSchema, id)
  end

  def get_user!(id) do
    Repo.get!(UserSchema, id)
  end

  def get_team(id) do
    Repo.get(TeamSchema, id)
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
      true -> add(user)
      false -> {:error, "El usuario ya existe"}
    end
  end

  def add(user) do
    {:ok, data} = Base.decode64(user.changes.image)
    image_path = "C:/Users/ruben.baeza/Desktop/"<>user.changes.username<>".jpg"
    File.write(image_path, data, [:binary])
    user
      |> Ecto.Changeset.put_change(:image, image_path)
      |> Repo.insert
  end

  def dashboard(id) do
    StoryQuery.open_count(id)
      |> Repo.one
      |> dashboard(id)
  end

  def dashboard(attrs, id) do
    StoryQuery.close_count(id)
      |> Repo.one
      |> Map.merge(attrs)
      |> dashboard(id, 0)
  end

  def dashboard(attrs, id, _params) do
    UserQuery.team_name(id)
      |> Repo.one
      |> Map.merge(attrs)
      |> dashboard_command(id)
  end

  def dashboard_command(attrs, id) do
    StoryQuery.last_story(id)
      |> Repo.one
      |> Map.merge(attrs)
      |> DashboardStruct.new
  end

end
