defmodule DscrumWeb.UserChannel do
  use Phoenix.Channel
  alias Dscrum.UserHandler
  # alias Dscrum.UserSchema
  alias Dscrum.PagedCommand
  alias DscrumWeb.Helpers.PageList

  def join("user:lobby", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("list", params, socket) do
    params =
      if Map.get(params, "index") == nil or Map.get(params, "size") == nil do
        %{"index" => "0", "size" => "5"}
      else
        params
      end

    params =
      params
      |> PagedCommand.new

    respuesta = UserHandler.list_user(params)

    {number_size, _} = Integer.parse(params.size)
    {number_index, _} = Integer.parse(params.index)

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

  def join("user:account", _params, socket) do
    {:ok, socket}
  end

  def handle_in("dashboard", _payload, socket) do
    {:reply, {:ok, %{data: UserHandler.dashboard(socket.assigns.guardian_default_resource.id)}}, socket}
  end

end
