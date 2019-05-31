defmodule Dscrum.MindStateHandler do
  alias Dscrum.Repo
  alias Dscrum.MindStateSchema
  alias Dscrum.MindStateStruct


  def list do
    Repo.all(MindStateSchema)
      |> Enum.map(fn(res) -> MindStateStruct.new(res) end)
  end

  def get_mind_state(id) do
    Repo.get(MindStateSchema, id)
  end

end
