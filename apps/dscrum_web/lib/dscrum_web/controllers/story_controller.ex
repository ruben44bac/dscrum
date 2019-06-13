defmodule DscrumWeb.StoryController do
  use DscrumWeb, :controller
  alias Dscrum.UserHandler
  alias Dscrum.StoryHandler
  alias Dscrum.TeamHandler
  alias Dscrum.StorySchema
  # alias Dscrum.PagedCommand
  # alias DscrumWeb.Helpers.PageList


  plug :check_auth when action in [:index, :show, :new, :create, :edit, :update, :delete]



  defp check_auth(conn, _args) do

    if user_id = get_session(conn, :current_user_id) do

      case Dscrum.Guardian.decode_and_verify(get_session(conn, :token)) do
        {:ok, _claims} ->
          current_user = UserHandler.get_user!(user_id)
          conn
          |> assign(:current_user, current_user)
        {:error, _invalid} ->
          conn
          # |> put_flash(:error, "Inicia sesion para continuar.")
          |> redirect(to: "/login")
          |> halt()
      end

    else
      conn
      # |> put_flash(:error, "Inicia sesion para continuar.")
      |> redirect(to: "/login")
      |> halt()
    end
  end

  def index(conn, params) do
    team_id = Map.get(params, "team_id")
    team = TeamHandler.get_team!(team_id)
    render(conn, "index_socket.html", csrf_token: get_csrf_token(), team_id: team_id, team: team)
  end

  def new(conn, params) do
    team_id = Map.get(params, "team_id")
    team = TeamHandler.get_team!(team_id)
    changeset = StorySchema.changeset(%StorySchema{}, %{})
    render(conn, "new.html", changeset: changeset, team_id: team_id, team: team)
  end


  def edit(conn, %{"id" => id}) do
    story = StoryHandler.get_story!(id)
    team = TeamHandler.get_team!(story.team_id)
    changeset = StorySchema.changeset(story, %{})
    render(conn, "edit.html", story: story, changeset: changeset, team: team)
  end


end
