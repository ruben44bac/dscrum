defmodule Dscrum.TeamSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team" do
    field :name, :string
    field :logotype, :string

    timestamps()
  end

  def changeset(team, attrs) do
    team
      |> cast(attrs, [:name, :logotype])
      |> validate_required([:name], message: "El valor es requerido")
  end

end
