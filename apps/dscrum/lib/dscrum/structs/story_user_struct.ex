defmodule Dscrum.StoryUserStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :name,
    :surname,
    :id,
    :username,
    :difficulty_name,
    :difficulty_id,
    :online
  ]
  use ExConstructor
end
