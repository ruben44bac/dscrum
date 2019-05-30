defmodule RumblWeb.CabeceraController do
  use DscrumWeb, :controller


  def index(conn, _params) do
      render conn, "cabecera.html"
  end

end
