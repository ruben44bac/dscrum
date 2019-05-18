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
      |> cast(attrs, [:username, :phone, :mail, :name, :surname, :password, :image])
      |> validate_required([:username, :phone, :mail, :name, :surname, :password],
        message: "El valor es requerido"
      )
      |> foreign_key_constraint(:team_id, name: :user_team_id_fkey, message: "")
  end

end




