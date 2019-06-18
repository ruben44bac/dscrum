defmodule Dscrum.StoryHandler do
  alias Dscrum.Repo
  alias Dscrum.StorySchema
  alias Dscrum.{
    PagedCommand,
    StoryCommand,
    FilterStoryCommand
  }
  alias Dscrum.StoryQuery
  alias Dscrum.StoryIterationQuery
  alias Dscrum.{
    StoryStruct,
    StoryPagedStruct,
    PagedStruct
  }
  alias Dscrum.Helpers.TotalPaginas

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

  def list_story(%PagedCommand{} = command, socket) do
    {number_size, _} = Integer.parse(command.size)
    {number_index, _} = Integer.parse(command.index)


    story_list =
      StoryQuery.paged_list(number_size, number_size * number_index, socket.assigns.team_id)
      |> Repo.all
      |> Repo.preload(:difficulty)
      |> Enum.map(fn(res) ->



          if not is_nil(res.date_end) do
            StoryStruct.new(res)
            |> Map.put(:date_start, DateTime.to_date(res.date_start))
            |> Map.put(:date_end, DateTime.to_date(res.date_end))
          else
            StoryStruct.new(res)
            |> Map.put(:date_start, DateTime.to_date(res.date_start))
            |> Map.put(:date_end, "")
          end


      end)

    total_records =
      StoryQuery.total_list(socket.assigns.team_id)
      |> Repo.one
      |> Map.get(:total)

    total_pages = TotalPaginas.total_paginas(total_records, 5)

    %{}
    |> Map.put(:records, story_list)
    |> Map.put(:total_pages, total_pages)
    |> Map.put(:total_records, total_records)
    |> PagedStruct.new()
    # %{attributes: result}
  end

  def list_story(%PagedCommand{} = params_paginado, %FilterStoryCommand{} = params_filter, socket) do
    {number_size, _} = Integer.parse(params_paginado.size)
    {number_index, _} = Integer.parse(params_paginado.index)

    story_list =
      StoryQuery.paged_list_filter(number_size, number_size * number_index, socket.assigns.team_id, params_filter)
      |> Repo.all
      |> Repo.preload(:difficulty)
      |> Enum.map(fn(res) ->



          if not is_nil(res.date_end) do
            StoryStruct.new(res)
            |> Map.put(:date_start, DateTime.to_date(res.date_start))
            |> Map.put(:date_end, DateTime.to_date(res.date_end))
          else
            StoryStruct.new(res)
            |> Map.put(:date_start, DateTime.to_date(res.date_start))
            |> Map.put(:date_end, "")
          end


      end)

    total_records =
      StoryQuery.total_list_filter(socket.assigns.team_id, params_filter)
      |> Repo.one
      |> Map.get(:total)

    total_pages = TotalPaginas.total_paginas(total_records, 5)

    %{}
    |> Map.put(:records, story_list)
    |> Map.put(:total_pages, total_pages)
    |> Map.put(:total_records, total_records)
    |> PagedStruct.new()
    # %{attributes: result}
  end


  def get_story!(id) do
    Repo.get!(StorySchema, id)
  end

  def get_story(id) do
    Repo.get(StorySchema, id)
    |> case do
      nil -> {:error, %{"#{inspect(__ENV__.function)}" => ["no records found"]}}
      result ->
          res =
            StoryStruct.new(result)
            |> Map.put(:date_start, DateTime.to_date(result.date_start))
            |> Map.put(:date_end, DateTime.to_date(result.date_end))
        {:ok, res}
    end
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

  def create(%StoryCommand{} = command) do
    %StorySchema{}
      |> StorySchema.changeset(Map.from_struct(
        command
          |> Map.put(:complete, false)))
      |> Repo.insert

  end

  def terminar(%StorySchema{} = story) do
    StoryIterationQuery.last_iteration_story_detail(story.id)
    |> Repo.one()
    |> case  do
      nil ->
        {:error, %{"terminar" => ["La historia debe tener al menos una iteración."]}}
      _ ->
        attrs_change = %{complete: true}

        story
        |> StorySchema.changeset(attrs_change)
        |> Repo.update()
        |> case do
          {:ok, result} ->
            {:ok, StoryStruct.new(result)}

          {:error, changeset} ->
            {:error, changeset}
        end

    end
  end

end
