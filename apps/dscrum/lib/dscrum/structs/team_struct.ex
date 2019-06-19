defmodule Dscrum.TeamStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :id,
    :name,
    :logotype,
    :users
  ]
  use ExConstructor
end
