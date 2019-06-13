defmodule DscrumWeb.StoryView do
  use DscrumWeb, :view
  alias DscrumWeb.StoryView
  alias Dscrum.StorySchema


  def render("index.json", %{story: story}) do
    %{data: render_many(story, StoryView, "story.json")}
  end

  def render("signin.json", %{storys: storys}) do
    %{data: render_many(storys, StoryView, "story.json")}
  end

  def render("show.json", %{story: story}) do
    %{data: render_one(story, StoryView, "story.json")}
  end

  def render("story.json", %{story: story}) do
    %{id: story.id,
      name: story.name,
      storyname: story.storyname,
      date_start: story.date_start,
      date_end: story.date_end,
      difficulty_id: story.difficulty_id,
      complete: story.complete}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{token: jwt}
  end


	def primer_nombre(%StorySchema{name: name}) do
		name
			|> String.split(" ")
			|> Enum.at(0)
	end

end
