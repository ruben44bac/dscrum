defmodule DscrumWeb.AuthController do
  use DscrumWeb, :controller
  alias Dscrum.AuthHandler
  alias Dscrum.AuthCommand

  def login(conn, attrs) do
    resp = attrs
      |> AuthCommand.new
      |> AuthHandler.login

    case resp do
      {:ok, mensaje} -> json conn, %{data: mensaje}
      {:error, mensaje} -> json conn, %{error: mensaje}
    end
  end
end
