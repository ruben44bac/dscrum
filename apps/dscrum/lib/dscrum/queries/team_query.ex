defmodule Dscrum.TeamQuery do
  import Ecto.Query
  alias Dscrum.TeamSchema

  def validate(name) do
    from t in TeamSchema,
    where:
      t.name == ^name
  end

  def validate(name, id) do
    from t in TeamSchema,
    where:
      t.name == ^name and t.id != ^id
  end


  def paged_list(size, index) do
    from t in TeamSchema,
    order_by: [asc: t.inserted_at],
    limit: ^size,
    offset: ^index
  end

  def total_list() do
    from t in TeamSchema,
    select: count(t.id)
  end
end
