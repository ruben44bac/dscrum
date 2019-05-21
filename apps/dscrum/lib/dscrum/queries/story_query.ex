defmodule Dscrum.StoryQuery do
  import Ecto.Query
  alias Dscrum.StorySchema

  def paged_list(size, index, team_id) do
    from s in StorySchema,
    where: s.team_id == ^team_id,
    order_by: [desc: s.date_start],
    limit: ^size,
    offset: ^index
  end

  def total_list(team_id) do
    from s in StorySchema,
    select: %{
      total: count(s.id)
    },
    where: s.team_id == ^team_id
  end

end
