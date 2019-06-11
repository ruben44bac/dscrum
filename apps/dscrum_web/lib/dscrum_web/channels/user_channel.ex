defmodule DscrumWeb.UserChannel do
  use Phoenix.Channel
  alias Dscrum.UserHandler

  def join("user:account", _params, socket) do
    {:ok, socket}
  end

  def handle_in("dashboard", _payload, socket) do
    {:reply, {:ok, %{data: UserHandler.dashboard(socket.assigns.guardian_default_resource.id)}}, socket}
  end

end
