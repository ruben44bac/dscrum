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


end
