defmodule Dscrum.StoryDetailStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :users,
    :name,
    :status,
    :difficulty_id,
    :difficulty_name,
    :date_start,
    :date_end
  ]
  use ExConstructor
end
