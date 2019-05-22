defmodule Dscrum.HistoryHandler do
  alias Dscrum.Repo
  alias Dscrum.StorySchema
  alias Dscrum.{
    PagedCommand,
    HistoryCommand
  }
  alias Dscrum.StoryQuery
  alias Dscrum.{
    StoryStruct,
    StoryPagedStruct
  }

  def list(%PagedCommand{} = command, socket) do
    story_list = StoryQuery.paged_list(command.size, (command.size * command.index), socket.assigns.team_id)
      |> Repo.all
      |> Enum.map(fn(res) -> StoryStruct.new(res) end)


    result = StoryQuery.total_list(socket.assigns.team_id)
      |> Repo.one
      |> StoryPagedStruct.new
      |> Map.put(:stories, story_list)

    %{attributes: result}
  end

  def new(%HistoryCommand{} = command) do

    result = %StorySchema{}
      |> StorySchema.changeset(Map.from_struct(command))
      |> Repo.insert
    case result do
      {:ok, res} -> res
        |> StoryStruct.new
      {:error, res} -> %{error: res}
    end
  end

end
