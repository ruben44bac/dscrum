defmodule DscrumWeb.SignupController do
  use DscrumWeb, :controller

  alias Dscrum.SignupHandler

  def signup(conn, attrs) do
    case SignupHandler.validate(attrs) do
      {:ok, _} -> json conn, %{data: "Usuario creado con éxito"}
      {:error, mensaje} -> json conn, %{error: mensaje}
    end

  end

end
