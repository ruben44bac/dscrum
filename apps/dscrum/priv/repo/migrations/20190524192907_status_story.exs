defmodule Dscrum.Repo.Migrations.StatusStory do
  use Ecto.Migration

  def up do
    alter table(:story) do
      add :complete, :boolean
    end
  end

  def down do
    alter table(:story) do
      remove :complete
    end
  end
end
