defmodule DscrumWeb.MindStateController do
  use DscrumWeb, :controller
  alias Dscrum.MindStateHandler

  def image(conn, attrs) do
    mind_state = MindStateHandler.get_mind_state(attrs["id"])
    {:ok, file} = File.read(mind_state.image)
    conn
    |> send_download({:binary, file}, filename: "mind_state.jpg")
  end
end
