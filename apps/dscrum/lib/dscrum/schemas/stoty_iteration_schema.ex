defmodule Dscrum.StoryIterationSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "story_iteration" do
    field :iteration, :integer
    field :difficulty_id, :integer

    belongs_to :story, Dscrum.StorySchema

    timestamps()
  end

  def changeset(story_iteration, attrs) do
    story_iteration
      |> cast(attrs, [:iteration, :difficulty_id, :story_id])
      |> unique_constraint(:id, name: "story_iteration_pkey", message: "Es requerido")
  end

end
