defmodule Dscrum.UserQuery do
  import Ecto.Query
  alias Dscrum.{
    UserSchema,
    TeamSchema
  }

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
    select: %{
      total: count(u.id)
    }
  end

  def team_name(user_id) do
    from u in UserSchema,
    join: t in TeamSchema,
    on: u.team_id == t.id,
    where: u.id == ^user_id,
    select: %{
      team_name: t.name
    }
  end

end
