defmodule Elidactyl.Schemas.Server.SubuserV1 do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset
  alias Elidactyl.Utils

  @type t :: %__MODULE__{}

  @derive {Jason.Encoder, only: [:user_id, :server_id]}

  schema "subusers" do
    field :uuid, :string
    field :username, :string
    field :email, :string
    field :image, :string
    field :"2fa_enabled", :boolean
    field :permissions, {:array, :string}

    timestamps(inserted_at: :created_at)
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, [:uuid, :username, :email, :image, :"2fa_enabled", :permissions])
    |> Changeset.validate_required([:email, :permissions])
  end

  @spec parse(map) :: t()
  def parse(%{"object" => "server_subuser", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
