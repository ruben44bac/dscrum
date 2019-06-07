defmodule DscrumWeb.StoryChannel do
  use Phoenix.Channel
  alias DscrumWeb.Presence
  alias Dscrum.Repo
  alias Dscrum.UserSchema
  alias Dscrum.{
    PagedCommand,
    StoryCommand
  }
  alias Dscrum.StoryHandler

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

  def handle_in("add", params, socket) do
    respuesta = params
      |> StoryCommand.new
      |> StoryHandler.new

    broadcast!(socket, "new_story", respuesta)
    {:reply, {:ok, %{data: "Registro exitoso de " <> respuesta.name }}, socket}
  end

end
