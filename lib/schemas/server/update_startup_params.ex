defmodule Elidactyl.Schemas.Server.UpdateStartupParams do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset

  @type t :: %__MODULE__{}

  @mandatory ~w[startup egg image]a
  @optional ~w[environment skip_scripts]a

  @derive {Jason.Encoder, only: @mandatory ++ @optional}

  embedded_schema do
    field :startup, :string
    field :environment, :map
    field :egg, :integer
    field :image, :string
    field :skip_scripts, :boolean
  end

  @spec changeset(t, map) :: Changeset.t
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory ++ @optional)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.validate_length(:startup, max: 255)
    |> Changeset.validate_number(:egg, greater_than: 0)
    |> Changeset.validate_length(:image, max: 255)
  end
end
