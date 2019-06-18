defmodule Dscrum.StorySchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "story" do
    field :name, :string
    field :date_start, :naive_datetime
    field :date_end, :naive_datetime
    # field :difficulty_id, :integer
    field :complete, :boolean

    belongs_to :difficulty, Dscrum.DifficultySchema
    belongs_to :team, Dscrum.TeamSchema
    timestamps()
  end

  def changeset(story, attrs) do
    story
      |> cast(attrs, [:name, :date_start, :date_end, :difficulty_id, :team_id, :complete])
      |> validate_required([:name, :date_start], message: "Valor requerido")
  end

end
