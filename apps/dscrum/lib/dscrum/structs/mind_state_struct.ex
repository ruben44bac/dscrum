defmodule Dscrum.MindStateStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :id,
    :name
  ]
  use ExConstructor
end
