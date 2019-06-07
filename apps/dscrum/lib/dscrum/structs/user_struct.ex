defmodule Dscrum.UserStruct do
  @derive {Jason.Encoder, except: []}
  defstruct [
    :id,
    :username,
    :phone,
    :mail,
    :name,
    :surname,
    :password,
    :image,
    :team_id
  ]
  use ExConstructor
end
