defmodule Dscrum.StoryQuery do
  import Ecto.Query
  alias Dscrum. {
    StorySchema,
    UserSchema,
    DifficultySchema
  }

  def paged_list(size, index, team_id) do
    from s in StorySchema,
    where: s.team_id == ^team_id,
    order_by: [desc: s.date_start],
    limit: ^size,
    offset: ^index
  end

  def total_list(team_id) do
    from s in StorySchema,
    select: %{
      total: count(s.id)
    },
    where: s.team_id == ^team_id
  end

  def detail(story_id) do
    from s in StorySchema,
    where: s.id ==  ^story_id,
    left_join: d in DifficultySchema,
    on: s.difficulty_id == d.id,
    select: %{
      name: s.name,
      status: s.complete,
      difficulty_id: s.difficulty_id,
      difficulty_name: d.name,
      date_start: s.date_start,
      date_end: s.date_end
    }
  end

  def detail_story_user(story_id, user_id) do
    from s in StorySchema,
    where: s.id == ^story_id,
    join: u in UserSchema,
    on: s.team_id == u.team_id,
    where: u.id != ^user_id,
    select: %{
      name: u.name,
      surename: u.surname,
      id: u.id,
      username: u.username
    }
  end

  def status(story_id) do
    from s in StorySchema,
    where: s.id == ^story_id,
    select: s.complete
  end

end
