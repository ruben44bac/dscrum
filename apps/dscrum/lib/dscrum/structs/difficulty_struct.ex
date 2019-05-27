defmodule Dscrum.DifficultyStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :name,
    :id
  ]
  use ExConstructor
end
