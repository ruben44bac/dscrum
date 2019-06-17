defmodule Dscrum.FilterStoryCommand do
  defstruct [
    filter_name: "",
    filter_difficulty: 0,
    filter_start_start: nil,
    filter_end_start: nil,
    filter_start_end: nil,
    filter_end_end: nil
  ]
  use ExConstructor
end
