defmodule Dscrum.StoryDetailHandler do
  alias Dscrum.Repo
  alias Dscrum.{
    StoryQuery,
    StoryIterationQuery,
    DifficultyQuery
  }
  alias Dscrum.{
    StoryDetailStruct,
    StoryUserStruct,
    DifficultyStruct
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
            |> validate_dif_nil(difficulty)

      _ -> command
            |> Map.put(:online, true)
            |> validate_dif_nil(difficulty)
    end
  end

  def validate_dif_nil(command, difficulty) do
    case difficulty do
      nil -> command
      _ -> command
            |> Map.put(:difficulty_name, difficulty.difficulty_name)
            |> Map.put(:difficulty_id, difficulty.difficulty_id)
    end
  end

  def difficulty_list() do
    DifficultyQuery.list
      |> Repo.all
      |> Enum.map(fn(res) -> DifficultyStruct.new(res) end)
  end

  def qualify(params, socket) do
    status = StoryQuery.status(socket.assigns.story_id)
              |> Repo.one
    case status do
      nil -> Dscrum.IterationHandler.validate_iteration(params, socket)
      false -> Dscrum.IterationHandler.validate_iteration(params, socket)
      true -> %{message: "La historia ya se ha cerrado"}
    end
  end

  def user(socket) do
    StoryQuery.user(socket.assigns.guardian_default_resource.id)
     |> Repo.one
  end


  def get_difficulty(id) do
    Repo.get(Dscrum.DifficultySchema, id)
  end


end
