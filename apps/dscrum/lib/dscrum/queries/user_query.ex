defmodule Dscrum.UserQuery do
  import Ecto.Query
  alias Dscrum.UserSchema

  def validate(username, mail) do
    from u in UserSchema,
    where:
      u.username == ^username or u.mail == ^mail
  end

  def validate(username, mail, id) do
    from u in UserSchema,
    where:
      (u.username == ^username or u.mail == ^mail) and u.id != ^id
  end

  def user_username(username) do
    from u in UserSchema,
    where:
      u.username == ^username
  end

  def user_team(team_id) do
    from u in UserSchema,
    where: u.team_id == ^team_id,
    select: u.id,
    order_by: [asc: u.id]
  end


  def paged_list(size, index) do
    from u in UserSchema,
    order_by: [asc: u.inserted_at],
    limit: ^size,
    offset: ^index
  end

  def total_list() do
    from u in UserSchema,
    select: count(u.id)
  end

end
