defmodule Elidactyl.Schemas.Server.Database do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset
  alias Elidactyl.Utils

  @type t :: %__MODULE__{}
  @mandatory [:server, :host, :database, :username, :remote, :max_connections]

  @derive {Jason.Encoder, only: @mandatory}

  embedded_schema do
    field :server, :integer
    field :host, :integer
    field :database, :integer
    field :username, :integer
    field :remote, :integer
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

  def parse(%{"object" => "databases", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
