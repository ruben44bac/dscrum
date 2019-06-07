defmodule Dscrum.PagedStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :records,
    :total_records,
    :total_pages
  ]
  use ExConstructor
end
