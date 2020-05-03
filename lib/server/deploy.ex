defmodule Elidactyl.Server.Deploy do
  @moduledoc false

  alias Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  embedded_schema do
    field :locations, {:array, :integer}
    field :dedicated_ip, :boolean
    field :port_range, {:array, :string}
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:locations, :dedicated_ip, :port_range])
    |> Changeset.validate_required([:dedicated_ip])
  end
end