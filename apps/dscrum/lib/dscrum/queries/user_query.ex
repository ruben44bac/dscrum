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
