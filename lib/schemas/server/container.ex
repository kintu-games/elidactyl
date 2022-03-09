defmodule Elidactyl.Schemas.Server.Container do
  @moduledoc false

  alias Ecto.Changeset
  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  use Ecto.Schema

  @behaviour Parser

  @type t :: %__MODULE__{
          startup_command: binary | nil,
          image: binary | nil,
          environment: Parser.json_map() | nil,
          installed: boolean | nil
        }

  @derive {Jason.Encoder, only: [:startup_command, :image, :environment, :installed]}

  @primary_key false
  embedded_schema do
    field(:startup_command, :string)
    field(:image, :string)
    field(:environment, :map)
    field(:installed, :boolean)
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:startup_command, :image, :environment, :installed])
    |> Changeset.validate_required([:startup_command, :image, :environment])
  end

  @impl Parser
  def parse(%{} = attributes) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes, ~w[environment]))
  end
end
