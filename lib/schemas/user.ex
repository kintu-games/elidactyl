defmodule Elidactyl.Schemas.User do
  @moduledoc false

  use Ecto.Schema

  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  @type t :: %__MODULE__{
    id: non_neg_integer | nil,
    external_id: binary | nil,
    uuid: Ecto.UUID.t | nil,
    username: binary | nil,
    email: binary | nil,
    first_name: binary | nil,
    last_name: binary | nil,
    password: binary | nil,
    "2fa": boolean | nil,
    root_admin: boolean | nil,
    language: binary | nil,
    created_at: NaiveDateTime.t | nil,
    updated_at: NaiveDateTime.t | nil,
  }

  @optional [:password, :external_id]
  @mandatory [:username, :email, :first_name, :last_name, :root_admin, :language]

  @derive {Jason.Encoder, only: @optional ++ @mandatory}

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

  @spec changeset(t(), map) :: Ecto.Changeset.t()
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

  @impl Parser
  def parse(%{"object" => "user", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
