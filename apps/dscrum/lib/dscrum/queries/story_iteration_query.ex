defmodule Dscrum.StoryIterationQuery do
  import Ecto.Query
  alias Dscrum.{
    StorySchema,
    DifficultySchema,
    StoryIterationSchema,
    UserStoryIterationSchema
  }

  def last_iteration_story(user_id, story_id) do
    from s in StorySchema,
    where: s.id == ^story_id,
    join: si in StoryIterationSchema,
    on: si.story_id == s.id,
    join: usi in UserStoryIterationSchema,
    on: usi.story_iteration_id == si.id,
    join: d in DifficultySchema,
    on: d.id == usi.difficulty_id,
    where: usi.user_id == ^user_id,
    order_by: [desc: usi.id],
    select: %{
      difficulty_id: usi.difficulty_id,
      difficulty_name: d.name
    },
    limit: 1
  end

  def last_iteration_story_detail(story_id) do
    from si in StoryIterationSchema,
    where: si.story_id == ^story_id,
    order_by: [desc: si.id],
    limit: 1
  end

  def user_actualy_iteration(user_id, story_iteration_id) do
    from usi in UserStoryIterationSchema,
    where: usi.story_iteration_id == ^story_iteration_id and usi.user_id == ^user_id
  end

  def user_iteration(story_iteration_id) do
    from usi in UserStoryIterationSchema,
    where: usi.story_iteration_id == ^story_iteration_id,
    select: usi.user_id,
    order_by: [asc: usi.user_id]
  end

  def calification_user(story_iteration_id) do
    from usi in UserStoryIterationSchema,
    where: usi.story_iteration_id == ^story_iteration_id,
    select: usi.difficulty_id
  end

end
