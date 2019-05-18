defmodule Dscrum.MindStateSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mind_state" do
    field :name, :string
    field :description, :string
    field :image, :string

    timestamps()
  end

  def changeset(mind_state, attrs) do
    mind_state
      |> cast(attrs, [:name, :description, :image])
      |> validate_required([:name, :description], message: "Valores requeridos")
  end

end
