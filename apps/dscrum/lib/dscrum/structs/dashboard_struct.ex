defmodule Dscrum.DashboardStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :team_name,
    :story_open,
    :story_close,
    :last_story_name
  ]
  use ExConstructor
end
