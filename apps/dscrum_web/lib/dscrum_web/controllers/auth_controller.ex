defmodule DscrumWeb.AuthController do
  use DscrumWeb, :controller

  def check(conn, _test) do
    json conn, %{user: "HOLAAAAAA", token: "token"}
  end
end
