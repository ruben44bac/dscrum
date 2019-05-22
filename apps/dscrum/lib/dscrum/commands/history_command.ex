defmodule Dscrum.HistoryCommand do
  defstruct [
    :name, :date_start, :date_end, :difficulty_id, :team_id
  ]
  use ExConstructor
end
