defmodule Elidactyl.User do
  use Ecto.Schema

  @optional [:password, :language, :root_admin, :external_id]
  @mandatory [:username, :email, :first_name, :last_name]

  @derive {Poison.Encoder, only: @optional ++ @mandatory}
  embedded_schema do
    field :external_id, :string
    field :uuid, Ecto.UUID
    field :username, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :"2fa", :boolean
    field :root_admin, :boolean
    field :language, :string
    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  def parse(%{object: "user", attributes: attributes}) do
    struct(__MODULE__, attributes)
  end

  def changeset(struct, params) do
    struct
    |> Ecto.Changeset.cast(params, @mandatory ++ @optional)
    |> Ecto.Changeset.validate_required(@mandatory)
    |> Ecto.Changeset.validate_format(:email, ~r/.+@.+\..+/)
    |> Ecto.Changeset.validate_length(:external_id, min: 1, max: 255)
    |> Ecto.Changeset.validate_length(:username, min: 1, max: 255)
    |> Ecto.Changeset.validate_length(:first_name, min: 1, max: 255)
    |> Ecto.Changeset.validate_length(:last_name, min: 1, max: 255)
  end
end