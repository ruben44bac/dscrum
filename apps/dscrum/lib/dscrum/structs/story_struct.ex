defmodule Dscrum.StoryStruct do
  @derive {Jason.Encoder, only: [:id,
  :name,
  :date_start,
  :date_end,
  :difficulty_id]}
  defstruct [
    :id,
    :name,
    :date_start,
    :date_end,
    :difficulty_id
  ]
  use ExConstructor
end
