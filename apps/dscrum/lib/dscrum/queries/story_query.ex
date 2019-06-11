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
    order_by: [desc: s.id],
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

  def user(user_id) do
    from u in UserSchema,
    where: u.id == ^user_id,
    select: %{
      user_id: u.id,
      username: u.username,
      name: u.name
    }
  end

  def open_count(user_id) do
    from u in UserSchema,
    where: u.id == ^user_id,
    join: s in StorySchema,
    on: s.team_id == u.team_id,
    where: s.complete != true or is_nil(s.complete),
    select: %{
      story_open: count(s.id)
    }
  end

  def close_count(user_id) do
    from u in UserSchema,
    where: u.id == ^user_id,
    join: s in StorySchema,
    on: s.team_id == u.team_id,
    where: s.complete == true,
    select: %{
      story_close: count(s.id)
    }
  end

  def last_story(user_id) do
    from u in UserSchema,
    where: u.id == ^user_id,
    join: s in StorySchema,
    on: s.team_id == u.team_id,
    select: %{
      last_story_name: s.name
    },
    order_by: [desc: s.id],
    limit: 1,
    offset: 0
  end

end
