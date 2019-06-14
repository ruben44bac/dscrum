defmodule Dscrum.StoryStruct do
  @moduledoc false
  alias __MODULE__, as: Story

  alias Dscrum.DifficultyStruct, as: Difficulty

  @derive {Jason.Encoder, except: []}
  defstruct [
    :id,
    :name,
    :date_start,
    :date_end,
    :difficulty_id,
    :difficulty,
    :team_id,
    :complete
  ]
  # use ExConstructor
  def new(story) do
    if is_nil(story) do
      %Story{}
    else
      %Story{
        id: story.id,
        name: story.name,
        date_start: story.date_start,
        date_end: story.date_end,
        difficulty_id: story.difficulty_id,
        team_id: story.team_id,
        complete: story.complete,
        difficulty:
          if(is_nil(story.difficulty),
            do: nil,
            else: Difficulty.new(story.difficulty)
          )
      }
    end
  end
end
