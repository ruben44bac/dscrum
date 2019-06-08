defmodule Dscrum.TeamStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :id,
    :name,
    :logotype
  ]
  use ExConstructor
end
