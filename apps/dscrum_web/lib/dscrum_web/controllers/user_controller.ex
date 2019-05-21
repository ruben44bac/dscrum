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

  def show(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    conn |> render("user.json", user: user)
 end


end
