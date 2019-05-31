defmodule DscrumWeb.MindStateChannel do
  use Phoenix.Channel

  alias Dscrum.MindStateHandler

  def join("mind_state:state", _params, socket) do
    {:ok, socket}
  end

  def handle_in("list", _payload, socket) do
    {:reply, {:ok, %{data: MindStateHandler.list}}, socket}
  end

end
