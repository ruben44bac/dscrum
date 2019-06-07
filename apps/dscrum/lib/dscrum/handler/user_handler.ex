defmodule Dscrum.UserHandler do

  import Ecto.Query, warn: false
  import Ecto.Changeset

  alias Dscrum.Repo
  alias Dscrum.UserSchema
  alias Dscrum.AuthCommand
  alias Dscrum.UserQuery
  alias Dscrum.Guardian
  alias Dscrum.PagedCommand
  alias Dscrum.{UserStruct, PagedStruct}

  def list_user() do
    UserSchema
    |> order_by([c], asc: c.inserted_at)
    |> Repo.all()
  end

  def list_user(%PagedCommand{} = command) do
    {number_size, _} = Integer.parse(command.size)
    {number_index, _} = Integer.parse(command.index)


    user_list =
      UserQuery.paged_list(number_size, number_size * number_index)
      |> Repo.all
      |> Enum.map(fn(res) -> UserStruct.new(res) end)

    total_records =
      UserQuery.total_list()
      |> Repo.one

    total_pages = total_paginas(total_records, 5)

    %{}
    |> Map.put(:records, user_list)
    |> Map.put(:total_pages, total_pages)
    |> Map.put(:total_records, total_records)
    |> PagedStruct.new()
    # %{attributes: result}
  end

  def list_user_sin_equipo() do
    UserSchema
    |> where([u], is_nil(u.team_id))
    |> order_by([u], asc: u.inserted_at)
    |> Repo.all()
  end

  def list_user_by_equipo(team_id) do
    UserSchema
    |> where([u], u.team_id == ^team_id)
    |> order_by([u], asc: u.inserted_at)
    |> Repo.all()
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

  def update_validate(%UserSchema{} = user, attrs) do

    user = user
    |> UserSchema.changeset(attrs)

    user =
      if Map.get(attrs, "password") == "***********" do
        user
        |> Ecto.Changeset.delete_change(:password)
      else
        user
        |> Ecto.Changeset.put_change(:password, Pbkdf2.hash_pwd_salt(Map.get(attrs, "password")))
      end

    id = get_field(user, :id)
    match = UserQuery.validate(user.params["username"], user.params["mail"], id)
      |> Repo.all()

    case (match == []) do
      true -> edit(user)
      false -> {:error, "El usuario ya existe"}
    end

    # |> Repo.update()
  end

  def create_validate(attrs) do
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
    |> Repo.insert()

  end

  def edit(user) do
    user =
      if not is_nil(user.changes.image) do
        {:ok, data} = Base.decode64(user.changes.image)
        image_path = "C:/Users/luis.moreno/Desktop/"<>user.params["username"]<>".jpg"
        File.write(image_path, data, [:binary])

        user
        |> Ecto.Changeset.put_change(:image, image_path)
      else
        user
        |> Ecto.Changeset.delete_change(:image)
      end

    Repo.update(user)

  end

  def delete_user(%UserSchema{} = user) do
    Repo.delete(user)
  end

  def update_team(%UserSchema{} = user, attrs) do
    user
    |> UserSchema.changeset(attrs)
    |> Repo.update()
  end

  defp ceiling(float) do
    t = trunc(float)

    case float - t do
      neg when neg < 0 ->
        t

      pos when pos > 0 ->
        t + 1

      _ ->
        t
    end
  end

  defp total_paginas(count, numero_elementos) do
    ceiling(count / numero_elementos)
  end

end
