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
end
