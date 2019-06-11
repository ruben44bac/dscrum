defmodule DscrumWeb.UserController do
  use DscrumWeb, :controller
  alias Dscrum.AuthCommand
  alias Dscrum.UserHandler

  def login(conn, attrs) do
    resp = attrs
      |> AuthCommand.new
      |> UserHandler.login
    case resp do
      {:ok, token, _claims} ->
        conn
          |> render("jwt.json", jwt: token)
      {:error, mensaje} -> json conn, %{error: mensaje}
    end
  end

  def signup(conn, attrs) do
    case UserHandler.validate(attrs) do
      {:ok, _} -> json conn, %{data: "Usuario creado con éxito"}
      {:error, mensaje} -> json conn, %{error: mensaje}
    end
  end

  def show(conn, _attrs) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
  end

  def image(conn, attrs) do
    user = UserHandler.get_user(attrs["id"])
    {:ok, file} = File.read(user.image)
    conn
    |> send_download({:binary, file}, filename: "user.jpg")
  end

  def image_team(conn, attrs) do
    team = UserHandler.get_team(attrs["id"])
    {:ok, file} = File.read(team.logotype)
    conn
    |> send_download({:binary, file}, filename: "team.jpg")
  end

end
