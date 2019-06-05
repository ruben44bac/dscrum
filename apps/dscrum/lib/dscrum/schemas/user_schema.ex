defmodule Dscrum.UserSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :username, :string
    field :phone, :string
    field :mail, :string
    field :name, :string
    field :surname, :string
    field :password, :string
    field :image, :string

    belongs_to :team, Dscrum.TeamSchema
    timestamps()
  end

  def changeset(user, attrs) do
    user
      |> cast(attrs, [:username, :phone, :mail, :name, :surname, :password, :image, :team_id])
      |> validate_required([:username, :phone, :mail, :name, :surname, :password],
        message: "El valor es requerido"
      )
      |> validate_length(:username, max: 150)
      |> validate_length(:phone, max: 20)
      |> validate_length(:mail, max: 120)
      |> validate_length(:name, max: 100)
      |> validate_length(:surname, max: 100)
      |> validate_length(:password, max: 500)
      |> foreign_key_constraint(:team_id, name: :user_team_id_fkey, message: "No hay equipo")
  end

end




