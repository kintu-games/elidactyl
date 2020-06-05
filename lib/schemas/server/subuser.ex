defmodule Elidactyl.Schemas.Server.Subuser do
  @moduledoc false

  alias Ecto.Changeset
  use Ecto.Schema

  @type t :: %__MODULE__{}

  @derive {Poison.Encoder, only: [:user_id, :server_id]}

  schema "subusers" do
    field :user_id, :integer
    field :server_id, :integer

    timestamps(inserted_at: :created_at)
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:user_id, :server_id])
    |> Changeset.validate_required([:user_id, :server_id])
  end
end