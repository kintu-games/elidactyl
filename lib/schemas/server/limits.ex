defmodule Elidactyl.Schemas.Server.Limits do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset

  @type t :: %__MODULE__{
          memory: non_neg_integer | nil,
          swap: integer | nil,
          disk: non_neg_integer | nil,
          io: non_neg_integer | nil,
          cpu: non_neg_integer | nil
        }

  @mandatory ~w[memory swap disk io cpu]a

  @derive {Jason.Encoder, only: @mandatory}

  @primary_key false
  embedded_schema do
    field(:memory, :integer)
    field(:swap, :integer)
    field(:disk, :integer)
    field(:io, :integer)
    field(:cpu, :integer)
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.validate_number(:memory, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:swap, greater_than_or_equal_to: -1)
    |> Changeset.validate_number(:disk, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:cpu, greater_than_or_equal_to: 0)
    |> Changeset.validate_inclusion(:io, 10..1000)
  end
end
