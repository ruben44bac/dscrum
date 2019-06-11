defmodule Dscrum.MindStateHandler do
  alias Dscrum.Repo
  alias Dscrum.{
    MindStateSchema,
    UserMindStateSchema
  }
  alias Dscrum.MindStateStruct


  def list do
    Repo.all(MindStateSchema)
      |> Enum.map(fn(res) -> MindStateStruct.new(res) end)
  end

  def get_mind_state(id) do
    Repo.get(MindStateSchema, id)
  end

  def qualify(%{"mind_state_id" => id, "note" => note}, user_id) do
    %UserMindStateSchema{}
      |> UserMindStateSchema.changeset(%{
          note: note,
          user_id: user_id,
          mind_state_id: id
        })
      |> Repo.insert
  end

end
