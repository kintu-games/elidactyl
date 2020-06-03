defmodule Elidactyl.Schemas.Server.FeatureLimits do
  @moduledoc false

  alias Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @derive {Poison.Encoder, only: [:databases, :allocations]}

  embedded_schema do
    field :databases, :integer
    field :allocations, :integer
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:databases, :allocations])
    |> Changeset.validate_required([:databases, :allocations])
    |> Changeset.validate_number(:databases, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:allocations, greater_than_or_equal_to: 0)
  end
end