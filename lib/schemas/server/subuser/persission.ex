defmodule Elidactyl.Schemas.Server.Subuser.Permission do
  @moduledoc false

  alias Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @derive {Jason.Encoder, only: [:user_id, :server_id]}

  schema "permissions" do
    field :subuser_id, :integer
    field :permission, :string
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:subuser_id, :permission])
    |> Changeset.validate_required([:subuser_id, :permission])
  end
end
