defmodule Dscrum.StoryPagedStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :stories,
    :total
  ]
  use ExConstructor
end
