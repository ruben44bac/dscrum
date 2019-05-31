defmodule DscrumWeb.UserView do
  use DscrumWeb, :view
  alias DscrumWeb.UserView
  alias Dscrum.UserSchema

  def render("signin.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      mail: user.mail,
      username: user.username,
      image: user.image,
      name: user.name,
      surname: user.surname,
      team_id: user.team_id}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{token: jwt}
  end


	def primer_nombre(%UserSchema{name: name}) do
		name
			|> String.split(" ")
			|> Enum.at(0)
	end

end
