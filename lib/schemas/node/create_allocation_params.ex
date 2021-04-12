defmodule Elidactyl.Schemas.Node.CreateAllocationParams do
  @moduledoc false

  use Ecto.Schema

  @type t :: %__MODULE__{
    ip: binary | nil,
    alias: binary | nil,
    ports: [binary] | nil,
  }

  @optional [:alias]
  @mandatory [:ip, :ports]

  @derive {Jason.Encoder, only: @optional ++ @mandatory}

  @primary_key false
  embedded_schema do
    field :ip, :string
    field :alias, :string
    field :ports, {:array, :string}
  end

  @spec changeset(t(), map) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> Ecto.Changeset.cast(params, @mandatory ++ @optional)
    |> Ecto.Changeset.validate_required(@mandatory)
  end
end
