defmodule Dscrum.StoryPagedStruct do
  @derive {Jason.Encoder, only: [:stories,
  :total]}
  defstruct [
    :stories,
    :total
  ]
  use ExConstructor
end
