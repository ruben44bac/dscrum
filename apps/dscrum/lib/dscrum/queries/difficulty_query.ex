defmodule Dscrum.DifficultyQuery do
  import Ecto.Query
  alias Dscrum.DifficultySchema

  def list() do
    from d in DifficultySchema,
    select: %{
      id: d.id,
      name: d.name
    },
    order_by: [asc: d.id]
  end

end
