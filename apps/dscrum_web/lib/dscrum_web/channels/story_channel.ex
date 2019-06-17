defmodule DscrumWeb.StoryChannel do
  use Phoenix.Channel
  alias DscrumWeb.Presence
  alias Dscrum.Repo
  alias Dscrum.UserSchema
  alias Dscrum.{
    PagedCommand,
    StoryCommand,
    FilterStoryCommand
  }
  alias Dscrum.StoryHandler
  alias DscrumWeb.Helpers.PageList
  alias Dscrum.StoryDetailHandler

  def join("history:" <> team_id, _params, socket) do
    send(self(), :after_join)
    {:ok, %{channel: "history:#{team_id}"}, assign(socket, :team_id, team_id)}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    IO.inspect(socket)
    IO.puts("**************************************")
    user = Repo.get(UserSchema, socket.assigns.guardian_default_resource.id)

    {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
      user_id: user.id,
      username: user.username
    })
    {:noreply, socket}
  end

  def handle_in("list", params, socket) do
    respuesta = params
      |> PagedCommand.new
      |> StoryHandler.list(socket)
    {:reply, {:ok, %{data: respuesta}}, socket}
  end

  def handle_in("list_paginado", params, socket) do
    params =
      if Map.get(params, "index") == nil or Map.get(params, "size") == nil do
        params
        |> Map.put(:index, "0")
        |> Map.put(:size, "5")
      else
        params
      end



    params_paginado =
      params
      |> PagedCommand.new

    params_filter =
      params
      |> FilterStoryCommand.new

    respuesta = StoryHandler.list_story(params_paginado, params_filter, socket)

    {number_size, _} = Integer.parse(params_paginado.size)
    {number_index, _} = Integer.parse(params_paginado.index)

    paginado = PageList.get_page_list(respuesta.total_pages, number_index, 7)

    result = %{
      records: respuesta.records,
      total_records: respuesta.total_records,
      total_pages: respuesta.total_pages,
      page_number: number_index,
      page_size: number_size,
      paginado: paginado
    }

    {:reply, {:ok, result}, socket}
  end

  def handle_in("difficulty_list", _params, socket) do
    {:reply, {:ok, %{data: StoryDetailHandler.difficulty_list }}, socket}
  end

  def handle_in("add", params, socket) do
    respuesta = params
      |> StoryCommand.new
      |> StoryHandler.new

    broadcast!(socket, "new_story", respuesta)
    {:reply, {:ok, %{data: "Registro exitoso de " <> respuesta.name }}, socket}
  end

  def handle_in("end",  %{"id" => id}, socket) do
    story = StoryHandler.get_story!(id)
    IO.inspect(story)
    with {:ok, story} <- StoryHandler.terminar(story) do
      broadcast!(socket, "end_story", story)
      {:reply, {:ok, story}, socket}
    else
      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

end
