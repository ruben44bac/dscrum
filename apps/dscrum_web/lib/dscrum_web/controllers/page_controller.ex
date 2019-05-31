defmodule DscrumWeb.PageController do
  use DscrumWeb, :controller

  alias Dscrum.UserHandler

  plug :check_auth when action in [:index, :new, :create, :edit, :update, :delete]



  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = UserHandler.get_user!(user_id)

      conn
      |> assign(:current_user, current_user)
    else
      conn
      |> put_flash(:error, "Inicia sesion para continuar.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def index(conn, _params) do
    # token = get_session(conn, :token)
    # current_user_id = get_session(conn, :current_user_id)

    render(conn, "index.html")
  end

end
