defmodule DscrumWeb.StoryDetailChannel  do
  use Phoenix.Channel
  alias DscrumWeb.Presence
  alias Dscrum.Repo
  alias Dscrum.UserSchema
  alias Dscrum.StoryDetailHandler

  def join("story_detail:" <> story_id,_params, socket) do
    send(self(), :after_join)
    {:ok, %{channel: "story_detail:#{story_id}"}, assign(socket, :story_id, story_id)}
  end

  def handle_info(:after_join, socket) do
    push socket, "precense_state", Presence.list(socket)
    user = Repo.get(UserSchema, socket.assigns.guardian_default_resource.id)
    user_map = %{ user_id: user.id, username: user.username, name: "#{user.name} #{user.surname}"}
    broadcast!(socket, "online", user_map)
    {:ok, _} = Presence.track(socket, "user_story:#{user.id}", user_map)
    {:noreply, socket}
  end

  def handle_in("index", _params, socket) do
    response = StoryDetailHandler.index(socket)
    {:reply, {:ok, %{data: response }}, socket}
  end

  def handle_in("difficulty_list", _params, socket) do
    {:reply, {:ok, %{data: StoryDetailHandler.difficulty_list }}, socket}
  end

  def handle_in("qualify", params, socket) do
    response = StoryDetailHandler.qualify(params, socket)
                |> check_status(socket)
    {:reply, {:ok, %{data: response }}, socket}
  end

  def handle_in("leave", _params, socket) do
    broadcast!(socket, "left", StoryDetailHandler.user(socket))
    {:noreply,socket}
  end

  def check_status(params, socket) do
    if(params.close == true) do
      broadcast!(socket, "close", %{difficulty: params.difficulty})
    end
    params
  end

end
