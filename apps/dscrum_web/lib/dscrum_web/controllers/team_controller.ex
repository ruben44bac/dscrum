defmodule DscrumWeb.TeamController do
  use DscrumWeb, :controller

  alias Dscrum.TeamHandler
  alias Dscrum.TeamSchema
  alias Dscrum.UserHandler

  plug :check_auth when action in [:index, :show, :new, :create, :edit, :update, :delete]



  defp check_auth(conn, _args) do
    if user_id = get_session(conn, :current_user_id) do
      current_user = UserHandler.get_user!(user_id)

      conn
      |> assign(:current_user, current_user)
    else
      conn
      # |> put_flash(:error, "Inicia sesion para continuar.")
      |> redirect(to: "/login")
      |> halt()
    end
  end


  def index(conn, _params) do
    teams = TeamHandler.list_teams()
    render(conn, "index.html", teams: teams)
  end

  def new(conn, _params) do
    users_sin_equipo = UserHandler.list_user()
    changeset = TeamHandler.change_team(%TeamSchema{})
    render(conn, "new.html", changeset: changeset, users_sin_equipo: users_sin_equipo)
  end

  def create(conn, %{"team_schema" => team_params}) do

    team_params =
      if upload = team_params["foto"] do

        with File.exists?(upload.path) do
          file = File.read!(upload.path)
          conve_base64 = Base.encode64(file)

          team_params
          |> Map.put("logotype", conve_base64)
        end

      else

        team_params
        |> Map.put("logotype", nil)
      end

    case TeamHandler.create_team(team_params) do
      {:ok, _team} ->
        conn
        # |> put_flash(:info, "Team created successfully.")
        |> redirect(to: Routes.team_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    team = TeamHandler.get_team!(id)
    render(conn, "show.html", team: team)
  end

  def edit(conn, %{"id" => id}) do
    users_sin_equipo = UserHandler.list_user()
    team = TeamHandler.get_team!(id)
    changeset = TeamHandler.change_team(team)
    render(conn, "edit.html", team: team, changeset: changeset, users_sin_equipo: users_sin_equipo)
  end

  def update(conn, %{"id" => id, "team_schema" => team_params}) do
    team = TeamHandler.get_team!(id)

    team_params =
      if upload = team_params["foto"] do

        with File.exists?(upload.path) do
          file = File.read!(upload.path)
          conve_base64 = Base.encode64(file)

          team_params
          |> Map.put("logotype", conve_base64)
        end

      else

        team_params
        |> Map.put("logotype", nil)
      end

    case TeamHandler.update_team(team, team_params) do
      {:ok, _team} ->
        conn
        # |> put_flash(:info, "Team updated successfully.")
        |> redirect(to: Routes.team_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", team: team, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = TeamHandler.get_team!(id)
    {:ok, _team} = TeamHandler.delete_team(team)

    conn
    # |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: Routes.team_path(conn, :index))
  end

  def image(conn, attrs) do
    team = TeamHandler.get_team(attrs["id"])
    {:ok, file} = File.read(team.logotype)
    conn
    |> send_download({:binary, file}, filename: "team.jpg")
  end

  def add_user_team(conn, %{"users" => users, "team" => team}) do


    TeamHandler.add_user_team(team, users)

    team = TeamHandler.get_team!(team)
    conn
    # |> put_flash(:info, "Team deleted successfully.")
    |> redirect(to: Routes.team_path(conn, :edit, team))
  end

end