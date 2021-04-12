defmodule Elidactyl.Schemas.Server.UpdateDetailsParams do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset

  @type t :: %__MODULE__{
    external_id: binary | nil,
    name: binary | nil,
    description: binary | nil,
    user: non_neg_integer | nil,
  }

  @mandatory [:name, :user]
  @optional [:external_id, :description]

  @derive {Jason.Encoder, only: @mandatory ++ @optional}

  @primary_key false
  embedded_schema do
    field :external_id, :string
    field :name, :string
    field :description, :string
    field :user, :integer
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory ++ @optional)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.validate_length(:external_id, min: 1, max: 191)
    |> Changeset.validate_length(:name, min: 1, max: 255)
  end
end
