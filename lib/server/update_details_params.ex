defmodule Elidactyl.Server.UpdateDetailsParams do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset

  @type t :: %__MODULE__{}
  @mandatory [:name, :user]
  @derive {Poison.Encoder, only: @mandatory}

  embedded_schema do
    field :external_id, :string
    field :name, :string
    field :description, :string
    field :user, :integer
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.validate_length(:external_id, min: 1, max: 191)
    |> Changeset.validate_length(:name, min: 1, max: 255)
  end
end