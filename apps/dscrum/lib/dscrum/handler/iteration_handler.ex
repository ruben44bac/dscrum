defmodule Dscrum.IterationHandler do
  alias Dscrum.Repo
  alias Dscrum.{
    StoryIterationQuery,
    UserQuery
  }
  alias Dscrum.{
    StoryIterationSchema,
    UserStoryIterationSchema
  }

  def validate_iteration(params, socket) do
    iteration = StoryIterationQuery.last_iteration_story_detail(socket.assigns.story_id)
    |> Repo.one
    case iteration do
      nil -> create_iteration(params, socket, 0)
      _ -> validate_user_iteration(params, socket, %{id: iteration.id, iteration: iteration.iteration})
    end
  end

  def create_iteration(params, socket, iteration) do
    new_iteration = %StoryIterationSchema{}
       |> StoryIterationSchema.changeset(%{
        iteration: iteration + 1,
        story_id: socket.assigns.story_id,
        difficulty_id: 0
       })
       |> Repo.insert
    create_calification(params, socket, new_iteration.id)
  end

  def validate_user_iteration(params, socket, iteration) do
    user_actualy_iteration = StoryIterationQuery.user_actualy_iteration(socket.assigns.guardian_default_resource.id, iteration.id)
      |> Repo.one

    case user_actualy_iteration do
      nil -> create_calification(params, socket, iteration.id)
      _ -> validate_other_user_iteration(params, socket, iteration)
    end
  end

  def create_calification(params, socket, iteration_id) do
    new_user_iteration = %UserStoryIterationSchema{}
      |> UserStoryIterationSchema.changeset(%{
        difficulty_id: params["difficulty_id"],
        description: params["description"],
        user_id: socket.assigns.guardian_default_resource.id,
        story_iteration_id: iteration_id
      })
      |> Repo.insert

      case new_user_iteration do
        {:ok, _} -> validate_other_user_iteration(socket, iteration_id)
        _ ->  %{error: "Error fatal.", close: true}
      end

  end

  def validate_other_user_iteration(params, socket, iteration) do
    user_team = UserQuery.user_team(socket.assigns.guardian_default_resource.team_id)
      |> Repo.all
    user_iteration = StoryIterationQuery.user_iteration(iteration.id)
      |> Repo.all
    case user_team == user_iteration do
      true -> create_iteration(params, socket, iteration.iteration)
      false -> %{error: "Espera a que el resto del equipo califique.", close: false}
    end
  end

  def validate_other_user_iteration(socket, iteration_id) do
    user_team = UserQuery.user_team(socket.assigns.guardian_default_resource.team_id)
      |> Repo.all
    user_iteration = StoryIterationQuery.user_iteration(iteration_id)
      |> Repo.all

    case user_team == user_iteration do
      true -> close_iteration(iteration_id)
      false -> %{message: "Se ha registrado tu calificación", close: false}
    end
  end

  def close_iteration(iteration_id) do
    difficulty_users = StoryIterationQuery.calification_user(iteration_id)
      |> Repo.all
    sum = Enum.sum(difficulty_users)
    count = Enum.count(difficulty_users)
    difficulty = Float.round(sum / count, 0)
                  |> Kernel.trunc
    iteration = Repo.get(StoryIterationSchema, iteration_id)
      |> StoryIterationSchema.changeset(%{
        difficulty_id: difficulty
      })
      |> Repo.update

    case iteration do
      {:ok, _} -> %{message: "Se ha registrado tu calificación y cerrado la iteración", close: true, difficulty: difficulty}
      {:error, detail} -> %{error: detail}
    end

  end

end
