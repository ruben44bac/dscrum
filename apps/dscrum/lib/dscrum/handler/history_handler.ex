defmodule Dscrum.HistoryHandler do
  alias Dscrum.Repo
  #alias Dscrum.StorySchema
  alias Dscrum.PagedCommand
  alias Dscrum.StoryQuery
  alias Dscrum.{
    StoryStruct,
    StoryPagedStruct
  }

  def list(%PagedCommand{} = command, socket) do

    story_list = StoryQuery.paged_list(command.size, command.index, socket.assigns.team_id)
      |> Repo.all
      |> Enum.map(fn(res) -> StoryStruct.new(res) end)


    result = StoryQuery.total_list(socket.assigns.team_id)
      |> Repo.one
      |> StoryPagedStruct.new
      |> Map.put(:stories, story_list)

      %{attributes: result}
  end

end
