defmodule Dscrum.UserStoryIterationSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_story_iteration" do
    field :difficulty_id, :integer
    field :description, :string

    belongs_to :user, Dscrum.UserSchema
    belongs_to :story_iteration, Dscrum.StoryIterationSchema

    timestamps()
  end

  def changeset(user_story_iteration, attrs) do
    user_story_iteration
      |> cast(attrs, [:difficulty_id, :description, :user_id, :story_iteration_id])
      |> validate_required([:difficulty_id], message: "El valor es requerido")
  end

end
