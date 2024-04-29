defmodule UsersApi.Admin.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :adress, :string
    field :email, :string
    field :name, :string
    field :role, :string
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :role, :adress])
    |> validate_required([:name, :email, :role, :adress])
    |> unique_constraint(:email)
  end
end
