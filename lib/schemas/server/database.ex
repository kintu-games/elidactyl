defmodule Elidactyl.Schemas.Server.Database do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset
  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  @type t :: %__MODULE__{
          id: non_neg_integer | nil,
          host: non_neg_integer | nil,
          server: non_neg_integer | nil,
          database: binary | nil,
          username: binary | nil,
          remote: binary | nil,
          max_connections: non_neg_integer | nil,
          created_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  @mandatory ~w[host database remote]a

  @derive {Jason.Encoder, only: @mandatory}

  embedded_schema do
    field(:host, :integer)
    field(:database, :string)
    field(:remote, :string)
    field(:server, :integer, virtual: true)
    field(:username, :string, virtual: true)
    field(:max_connections, :integer, virtual: true)
    field(:created_at, :naive_datetime, virtual: true)
    field(:updated_at, :naive_datetime, virtual: true)
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
  end

  @impl Parser
  def parse(%{"object" => "databases", "attributes" => attributes}) do
    struct(__MODULE__, attributes |> Utils.keys_to_atoms() |> Utils.parse_timestamps())
  end
end
