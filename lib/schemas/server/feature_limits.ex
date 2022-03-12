defmodule Elidactyl.Schemas.Server.FeatureLimits do
  @moduledoc false

  alias Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{
          databases: non_neg_integer | nil,
          backups: non_neg_integer | nil
        }

  @mandatory ~w[databases backups]a

  @derive {Jason.Encoder, only: @mandatory}

  @primary_key false
  embedded_schema do
    field(:databases, :integer)
    field(:backups, :integer)
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.validate_number(:databases, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:backups, greater_than_or_equal_to: 0)
  end
end
