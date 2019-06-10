defmodule DscrumWeb.SessionController do
  use DscrumWeb, :controller

  alias Dscrum.UserHandler
  alias Dscrum.AuthCommand
  alias Dscrum.UserQuery
  alias Dscrum.Repo

  def new(conn, _params) do
    if get_session(conn, :current_user_id) do
      case Dscrum.Guardian.decode_and_verify(get_session(conn, :token)) do
        {:ok, _claims} ->
          current_user = UserHandler.get_user!(get_session(conn, :current_user_id))
          conn
          |> assign(:current_user, current_user)
          |> redirect(to: "/")
        {:error, _invalid} ->
          render conn, "new.html"
      end
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
        # |> put_flash(:info, "Sesión iniciada correctamente.")
        |> redirect(to: "/")
      {:error, mensaje} ->
        conn
        |> put_flash(:error, mensaje)
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:token)
    |> delete_session(:current_user_id)
    # |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: "/")
  end

end
