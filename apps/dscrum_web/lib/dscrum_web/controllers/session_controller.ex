defmodule DscrumWeb.SessionController do
  use DscrumWeb, :controller

  alias Dscrum.UserHandler
  alias Dscrum.AuthCommand
  alias Dscrum.UserQuery
  alias Dscrum.Repo

  def new(conn, _params) do
    if get_session(conn, :current_user_id) do
      render conn, "/"
    end
    render conn, "new.html"
  end

  def create(conn, session_params) do
    resp = session_params
      |> AuthCommand.new
      |> UserHandler.login

    user = UserQuery.user_username(session_params["username"])
      |> Repo.one

    case resp do
      {:ok, token, _claims} ->
        conn
        |> put_session(:token, token)
        |> put_session(:current_user_id, user.id)
        |> put_flash(:info, "Sesión iniciada correctamente.")
        |> redirect(to: "/")
      {:error, mensaje} ->
        conn
        |> put_flash(:error, mensaje)
        |> render("new.html")
    end
  end

end
