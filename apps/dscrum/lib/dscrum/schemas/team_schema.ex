defmodule Dscrum.TeamSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team" do
    field :name, :string
    field :logotype, :string

    timestamps()

    has_many(:user, Dscrum.UserSchema, foreign_key: :team_id)
    has_many(:story, Dscrum.StorySchema, foreign_key: :team_id)
  end

  def changeset(team, attrs) do
    team
      |> cast(attrs, [:name, :logotype])
      |> validate_required([:name], message: "El valor es requerido")
      |> no_assoc_constraint(:user)
      |> no_assoc_constraint(:story)
  end

end
