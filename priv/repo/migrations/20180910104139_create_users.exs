defmodule Golf.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :provider, :string
      add :token, :string
      add :admin, :boolean, default: false, null: false

      timestamps()
    end

  end
end
