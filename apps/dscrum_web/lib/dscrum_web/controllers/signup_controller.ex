defmodule DscrumWeb.SignupController do
  use DscrumWeb, :controller

  def signup(conn, valores) do
    json conn, valores
  end

end
