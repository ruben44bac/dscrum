defmodule Dscrum.TeamHandler do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset
  alias Dscrum.Repo

  alias Dscrum.PagedCommand
  alias Dscrum.TeamSchema
  alias Dscrum.TeamQuery
  alias Dscrum.UserHandler
  alias Dscrum.Helpers.TotalPaginas
  alias Dscrum.{TeamStruct, PagedStruct}
  @doc """
  Returns the list of teams.

  ## Examples

      iex> list_teams()
      [%TeamSchema{}, ...]

  """
  def list_teams do
    TeamSchema
    |> order_by([t], asc: t.inserted_at)
    |> Repo.all()
    |> Enum.map(fn result ->
      users_team = UserHandler.list_user_by_equipo(result.id)

      result
      |> Map.put(:users, users_team)
    end)
  end

  def list_teams(%PagedCommand{} = command) do
    {number_size, _} = Integer.parse(command.size)
    {number_index, _} = Integer.parse(command.index)


    team_list =
      TeamQuery.paged_list(number_size, number_size * number_index)
      |> Repo.all
      |> Enum.map(fn(res) ->
        users_team = UserHandler.list_user_by_equipo(res.id)

        TeamStruct.new(res)
        |> Map.put(:users, users_team)
      end)

    total_records =
      TeamQuery.total_list()
      |> Repo.one

    total_pages = TotalPaginas.total_paginas(total_records, 5)

    %{}
    |> Map.put(:records, team_list)
    |> Map.put(:total_pages, total_pages)
    |> Map.put(:total_records, total_records)
    |> PagedStruct.new()
    # %{attributes: result}
  end

  @doc """
  Gets a single team.

  Raises `Ecto.NoResultsError` if the TeamSchema does not exist.

  ## Examples

      iex> get_team!(123)
      %TeamSchema{}

      iex> get_team!(456)
      ** (Ecto.NoResultsError)

  """

  def get_team(id) do
    Repo.get(TeamSchema, id)
  end

  def get_team!(id) do

    team = Repo.get!(TeamSchema, id)
    {:ok, file} = File.read(team.logotype)

    team
     |> Map.put(:logotype, Base.encode64(file))

  end

  @doc """
  Creates a team.

  ## Examples

      iex> create_team(%{field: value})
      {:ok, %TeamSchema{}}

      iex> create_team(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team(attrs \\ %{}) do

    team =
      %TeamSchema{}
      |> TeamSchema.changeset(attrs)


    match =
      TeamQuery.validate(team.params["name"])
      |> Repo.all()

    case (match == []) do
      true -> save_image(team)
      false -> {:error, "El equipo ya existe"}
    end

  end

  @doc """
  Updates a team.

  ## Examples

      iex> update_team(team, %{field: new_value})
      {:ok, %TeamSchema{}}

      iex> update_team(team, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team(%TeamSchema{} = team, attrs) do
    team =
      team
      |> TeamSchema.changeset(attrs)

    id = get_field(team, :id)

    match =
      TeamQuery.validate(team.params["name"], id)
      |> Repo.all()

    case (match == []) do
      true -> save_image(team)
      false -> {:error, "El equipo ya existe"}
    end

  end

  @doc """
  Deletes a TeamSchema.

  ## Examples

      iex> delete_team(team)
      {:ok, %TeamSchema{}}

      iex> delete_team(team)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team(%TeamSchema{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.

  ## Examples

      iex> change_team(team)
      %Ecto.Changeset{source: %TeamSchema{}}

  """
  def change_team(%TeamSchema{} = team) do
    TeamSchema.changeset(team, %{})
  end


  def save_image(team_changeset) do
    team_changeset =
      if not is_nil(team_changeset.changes.logotype) do
        {:ok, data} = Base.decode64(team_changeset.changes.logotype)
        image_path = "C:/Users/luis.moreno/Desktop/"<>team_changeset.params["name"]<>".jpg"
        File.write(image_path, data, [:binary])

        team_changeset
        |> Ecto.Changeset.put_change(:logotype, image_path)
      else
        team_changeset
        |> Ecto.Changeset.delete_change(:logotype)
      end

    id = get_field(team_changeset, :id)

    if not is_nil(id) do
      Repo.update(team_changeset)
    else
      Repo.insert(team_changeset)
    end

  end

  def add_user_team(team, users) do
    users
    |> Enum.each(fn e ->
      user = UserHandler.get_user!(e)
      attrs = %{"team_id" => team}
      UserHandler.update_team(user, attrs)
    end)
  end

  def delete_user_team(_team_id, user_id) do
    user = UserHandler.get_user!(user_id)
    attrs = %{"team_id" => nil}
    UserHandler.update_team(user, attrs)
  end

end