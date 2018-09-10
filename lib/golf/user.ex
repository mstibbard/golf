defmodule Golf.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :provider, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :provider, :token, :admin])
    |> validate_required([:first_name, :last_name, :email, :provider, :token, :admin])
  end
end
