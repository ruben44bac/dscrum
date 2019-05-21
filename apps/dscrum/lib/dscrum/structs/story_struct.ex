defmodule Dscrum.StoryStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :id,
    :name,
    :date_start,
    :date_end,
    :difficulty_id
  ]
  use ExConstructor
end
