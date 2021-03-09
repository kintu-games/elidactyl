defmodule Elidactyl.Schemas.Node.CreateAllocationParams do
  @moduledoc false

  use Ecto.Schema
  alias Elidactyl.Utils

  @type t :: %__MODULE__{}

  @optional [:alias]
  @mandatory [:ip, :ports]

  @derive {Jason.Encoder, only: @optional ++ @mandatory}
  embedded_schema do
    field :ip, :string
    field :alias, :string
    field :ports, {:array, :string}
  end

  @spec parse(map) :: t()
  def parse(%{"object" => "allocation", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end

  @spec changeset(t(), map) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> Ecto.Changeset.cast(params, @mandatory ++ @optional)
    |> Ecto.Changeset.validate_required(@mandatory)
  end
end
