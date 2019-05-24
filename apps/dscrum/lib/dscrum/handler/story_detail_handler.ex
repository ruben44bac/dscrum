defmodule Dscrum.StoryDetailHandler do
  alias Dscrum.Repo
  alias Dscrum.StoryQuery
  alias Dscrum.StoryDetailStruct

  def index(socket) do
    users = StoryQuery.detail_story_user(socket.assigns.story_id, socket.assigns.guardian_default_resource.id)
      |> Repo.all

    last_difficulty(users)
    socket.assigns.story_id
      |> StoryQuery.detail
      |> Repo.one
      |> StoryDetailStruct.new
      |> Map.put(:users, users)
  end

  def last_difficulty([head | tail]) do
    IO.puts("*/-/-*/*/*-/-/-/-*/-*/-*/*/***/-*/-*/-*/-*/*")
    IO.inspect(head)
    IO.puts("*/-/-*/*/*-/-/-/-*/-*/-*/*/***/-*/-*/-*/-*/*")
    last_difficulty(tail)
  end
  def last_difficulty([]), do: nil
end
