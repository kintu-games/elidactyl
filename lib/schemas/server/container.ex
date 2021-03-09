defmodule Elidactyl.Schemas.Server.Container do
  @moduledoc false

  alias Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @derive {Jason.Encoder, only: [:startup_command, :image, :environment, :installed]}

  embedded_schema do
    field :startup_command, :string
    field :image, :string
    field :environment, :map
    field :installed, :boolean
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:startup_command, :image, :environment, :installed])
    |> Changeset.validate_required([:startup_command, :image, :environment])
  end
end
