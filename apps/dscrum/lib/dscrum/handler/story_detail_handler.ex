defmodule Dscrum.StoryDetailHandler do
  alias Dscrum.Repo
  alias Dscrum.{
    StoryQuery,
    StoryIterationQuery
  }
  alias Dscrum.{
    StoryDetailStruct,
    StoryUserStruct
  }
  alias DscrumWeb.Presence


  def index(socket) do
    users = StoryQuery.detail_story_user(socket.assigns.story_id, socket.assigns.guardian_default_resource.id)
      |> Repo.all
      |> Enum.map(fn(res) ->
          StoryUserStruct.new(res)
            |> last_difficulty(socket.assigns.story_id, socket)
        end)
    socket.assigns.story_id
      |> StoryQuery.detail
      |> Repo.one
      |> StoryDetailStruct.new
      |> Map.put(:users, users)
  end

  def last_difficulty(%StoryUserStruct{} = command, story_id, socket) do
    difficulty = StoryIterationQuery.last_iteration_story(command.id, story_id)
      |> Repo.one
    case Presence.list(socket)["user_story:" <> Integer.to_string(command.id)] do
      nil -> command
            |> Map.put(:online, false)
            |> Map.put(:difficulty_name, difficulty.difficulty_name)
            |> Map.put(:difficulty_id, difficulty.difficulty_id)
      _ -> command
            |> Map.put(:online, true)
            |> Map.put(:difficulty_name, difficulty.difficulty_name)
            |> Map.put(:difficulty_id, difficulty.difficulty_id)
    end

  end
end
