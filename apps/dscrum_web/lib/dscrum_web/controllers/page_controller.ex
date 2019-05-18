defmodule DscrumWeb.PageController do
  use DscrumWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
