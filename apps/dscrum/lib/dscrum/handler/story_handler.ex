defmodule Dscrum.StoryHandler do
  alias Dscrum.Repo
  alias Dscrum.StorySchema
  alias Dscrum.{
    PagedCommand,
    StoryCommand
  }
  alias Dscrum.StoryQuery
  alias Dscrum.{
    StoryStruct,
    StoryPagedStruct
  }

  def list(%PagedCommand{} = command, socket) do
    StoryQuery.paged_list(command.size, (command.size * command.index), socket.assigns.team_id)
      |> Repo.all
      |> Enum.map(fn(res) -> StoryStruct.new(res) end)
      |> list(socket)
  end

  def list(story_list, socket) do
    result = StoryQuery.total_list(socket.assigns.team_id)
      |> Repo.one
      |> StoryPagedStruct.new
      |> Map.put(:stories, story_list)

    %{attributes: result}
  end

  def new(%StoryCommand{} = command) do
    result = %StorySchema{}
      |> StorySchema.changeset(Map.from_struct(
        command
          |> Map.put(:complete, false)))
      |> Repo.insert
    case result do
      {:ok, res} -> res
        |> StoryStruct.new
      {:error, res} -> %{error: res}
    end
  end

end
