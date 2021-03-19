defmodule Elidactyl.Schemas.Node.Allocation do
  @moduledoc false

  use Ecto.Schema

  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  @type t :: %__MODULE__{}

  @optional []
  @mandatory []

  @derive {Jason.Encoder, only: @optional ++ @mandatory}

  embedded_schema do
    field :ip, :string
    field :alias, :string
    field :port, :string
    field :assigned, :boolean
  end

  @spec changeset(t(), map) :: Ecto.Changeset.t()
  def changeset(struct, params) do
    struct
    |> Ecto.Changeset.cast(params, @mandatory ++ @optional)
    |> Ecto.Changeset.validate_required(@mandatory)
  end

  @impl Parser
  def parse(%{"object" => "allocation", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
