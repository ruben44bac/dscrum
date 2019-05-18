defmodule Dscrum.Repo.Migrations.CreacionTablas do
  use Ecto.Migration

  def change do

    create table(:team) do
      add :name, :string, size: 100
      add :logotype, :string, size: 200
      timestamps()
    end

    create table(:user) do
      add :username, :string, size: 150
      add :phone, :string, size: 20
      add :mail, :string, size: 120
      add :name, :string, size: 100
      add :surname, :string, size: 100
      add :password, :string, size: 500
      add :image, :string, size: 200

      add :team_id, references(:team)
      timestamps()
    end

    create table(:difficulty) do
      add :name, :string, size: 50
      add :description, :string, size: 300
      add :image, :string, size: 200
      timestamps()
    end

    create table(:story) do
      add :name, :string, size: 100
      add :date_start, :naive_datetime
      add :date_end, :naive_datetime
      add :difficulty_id, :integer

      add :team_id, references(:team)
      timestamps()
    end

    create table(:user_story) do
      add :difficulty_id, :integer
      add :description, :string, size: 300

      add :user_id, references(:user)
      add :story_id, references(:story)
      timestamps()
    end

    create table(:mind_state) do
      add :name, :string, size: 100
      add :description, :string, size: 300
      add :image, :string, size: 200

      timestamps()
    end

    create table(:user_mind_state) do
      add :note, :string, size: 300

      add :user_id, references(:user)
      add :mind_state_id, references(:mind_state)

      timestamps()
    end

  end
end
