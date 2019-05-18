defmodule Dscrum.UserStorySchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_story" do
    field :difficulty_id, :integer
    field :description, :string

    belongs_to :user, Dscrum.UserSchema
    belongs_to :story, Dscrum.StorySchema

    timestamps()
  end

  def changeset(user_story, attrs) do
    user_story
      |> cast(attrs, [:difficulty_id, :description])
      |> validate_required([:difficulty_id], message: "El valor es requerido")
  end

end
