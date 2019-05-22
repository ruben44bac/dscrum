defmodule Dscrum.Repo.Migrations.UpdateLenghtImage do
  use Ecto.Migration

  def change do
    alter table(:user) do
      modify :image, :string, size: 500
    end
  end
end
