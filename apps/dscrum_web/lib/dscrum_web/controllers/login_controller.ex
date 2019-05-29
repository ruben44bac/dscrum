defmodule DscrumWeb.LoginController do
  use DscrumWeb, :controller

  alias Dscrum.UserHandler
  alias Dscrum.AuthCommand


  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, session_params) do


    resp = session_params
      |> AuthCommand.new
      |> UserHandler.login
    case resp do
      {:ok, _token, _claims} ->
        conn
        |> redirect(to: "/")
      {:error, mensaje} ->
        conn
        |> put_flash(:error, mensaje)
        |> render("new.html")
    end

    # if session_params["username"] == "Luis" do
    #   conn
    #   |> redirect(to: "/")
    # else
    #   conn
    #   |> put_flash(:error, "Incorrect email or password")
    #   |> render("new.html")
    # end
  end

end
