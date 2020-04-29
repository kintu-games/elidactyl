defmodule Elidactyl.User do
  @derive {Poison.Encoder, only: [:object, :attributes]}

  use Ecto.Schema

  embedded_schema do
    field :external_id, :id
    field :uuid, Ecto.UUID
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :"2fa", :string
    field :root_admin, :string
    field :language, :string
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  def parse(%{object: "user", attributes: attributes}) do
    struct(__MODULE__, attributes)
  end
end