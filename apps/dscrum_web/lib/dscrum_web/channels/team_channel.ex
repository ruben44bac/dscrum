defmodule DscrumWeb.TeamChannel do
  use Phoenix.Channel
  alias Dscrum.TeamHandler
  # alias Dscrum.TeamSchema
  alias Dscrum.PagedCommand
  alias DscrumWeb.Helpers.PageList
  alias Ecto.Changeset

  def join("team:lobby", _params, socket) do
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

    respuesta = TeamHandler.list_teams(params)

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

  def handle_in("delete", %{"id" => id}, socket) do
    team = TeamHandler.get_team!(id)

    with {:ok, _team} <- TeamHandler.delete_team(team) do
      {:reply, {:ok, {}}, socket}
    else
      {:error, changeset} ->
        errors = errors(changeset)

        {:reply, {:error, %{errors: errors}}, socket}
    end
  end

  defp errors(%Ecto.Changeset{} = changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      if Enum.count(opts) == 0 do
        mensaje = Enum.reduce(opts, msg, fn {key, value}, acc ->
          Gettext.dgettext(DscrumWeb.Gettext, "errors",String.replace(acc, "%{#{key}}", to_string(value)))
        end)
        Gettext.dgettext(DscrumWeb.Gettext, "errors", mensaje)
      else
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          Gettext.dgettext(DscrumWeb.Gettext, "errors",String.replace(acc, "%{#{key}}", to_string(value)))
        end)
      end
    end)
  end

end
