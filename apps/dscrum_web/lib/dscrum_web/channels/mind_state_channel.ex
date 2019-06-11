defmodule DscrumWeb.MindStateChannel do
  use Phoenix.Channel

  alias Dscrum.MindStateHandler

  def join("mind_state:state", _params, socket) do
    {:ok, socket}
  end

  def handle_in("list", _payload, socket) do
    {:reply, {:ok, %{data: MindStateHandler.list}}, socket}
  end

  def handle_in("qualify", payload, socket) do
    response = payload
      |> MindStateHandler.qualify(socket.assigns.guardian_default_resource.id)
    case response do
      {:ok, _} -> {:reply, {:ok, %{data: "Tu estado de ánimo ha sido actualizado"}}, socket}
      _ -> {:reply, {:error, %{result: "No se ha podido registrar"}}, socket}
    end

  end

end
