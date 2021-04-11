defmodule Elidactyl.Schemas.Server.Database do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset
  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  @type t :: %__MODULE__{
    id: non_neg_integer | nil,
    server: non_neg_integer | nil,
    database: binary | nil,
    username: binary | nil,
    remote: binary | nil,
    max_connections: non_neg_integer | nil,
    created_at: NaiveDateTime.t | nil,
    updated_at: NaiveDateTime.t | nil,
  }

  @mandatory [:server, :host, :database, :username, :remote, :max_connections]

  @derive {Jason.Encoder, only: @mandatory}

  embedded_schema do
    field :server, :integer
    field :host, :integer
    field :database, :string
    field :username, :string
    field :remote, :string
    field :max_connections, :integer

    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.validate_number(:max_connections, greater_than_or_equal_to: 0)
  end

  @impl Parser
  def parse(%{"object" => "databases", "attributes" => attributes}) do
    struct(__MODULE__, attributes |> Utils.keys_to_atoms() |> Utils.parse_timestamps())
  end
end
