defmodule Elidactyl.Schemas.Server.Database do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset
  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  @type t :: %__MODULE__{}
  @mandatory ~w[host database remote]a

  @derive {Jason.Encoder, only: @mandatory}

  embedded_schema do
    field :host, :integer
    field :database, :string
    field :remote, :string
    field :server, :integer, virtual: true
    field :username, :string, virtual: true
    field :max_connections, :integer, virtual: true
    field :created_at, :naive_datetime, virtual: true
    field :updated_at, :naive_datetime, virtual: true
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
  end

  @impl Parser
  def parse(%{"object" => "databases", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
