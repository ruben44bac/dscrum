defmodule DscrumWeb.DifficultyController do
  use DscrumWeb, :controller
  alias Dscrum.StoryDetailHandler

  def image(conn, attrs) do
    diff = StoryDetailHandler.get_difficulty(attrs["id"])
    {:ok, file} = File.read(diff.image)
    conn
    |> send_download({:binary, file}, filename: "difficulty.png")
  end
end
