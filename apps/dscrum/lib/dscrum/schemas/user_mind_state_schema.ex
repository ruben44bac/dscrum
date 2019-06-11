defmodule Dscrum.UserMindStateSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_mind_state" do
    field :note, :string

    belongs_to :user, Dscrum.UserSchema
    belongs_to :mind_state, Dscrum.MindStateSchema

    timestamps()
  end

  def changeset(user_mind_state, attrs) do
    user_mind_state
      |> cast(attrs, [:note, :user_id, :mind_state_id])
  end

end
