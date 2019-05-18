defmodule Dscrum.DifficultySchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "difficulty" do
    field :name, :string
    field :description, :string
    field :image, :string

    timestamps()
  end

  def changeset(difficulty, attrs) do
    difficulty
      |> cast(attrs, [:name, :description, :image])
      |> validate_required([:name], message: "Datos requeridos")
  end

end
