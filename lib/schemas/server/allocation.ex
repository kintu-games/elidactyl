defmodule Elidactyl.Schemas.Server.Allocation do
  @moduledoc false

  alias Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{
    id: non_neg_integer | nil,
    default: non_neg_integer | nil,
    additional: [integer] | nil,
  }

  @derive {Jason.Encoder, only: [:default, :additional]}

  embedded_schema do
    field :default, :integer
    field :additional, {:array, :integer}
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:default, :additional])
    |> Changeset.validate_required([:default, :additional])
    |> Changeset.validate_number(:default, greater_than_or_equal_to: 0)
  end
end
