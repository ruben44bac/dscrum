defmodule Dscrum.StoryCommand do
  defstruct [
    :name, :date_start, :date_end, :difficulty_id, :team_id, :complete
  ]
  use ExConstructor
end
