defmodule Elidactyl.Schemas.Node.CreateNodeParams do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset

  @type t :: %__MODULE__{
          name: binary | nil,
          location_id: non_neg_integer | nil,
          fqdn: binary | nil,
          scheme: binary | nil,
          memory: non_neg_integer | nil,
          memory_overallocate: integer | nil,
          disk: non_neg_integer | nil,
          disk_overallocate: integer | nil,
          upload_size: non_neg_integer | nil,
          daemon_sftp: non_neg_integer | nil,
          daemon_listen: non_neg_integer | nil
        }

  @mandatory ~w[name location_id fqdn scheme memory memory_overallocate disk disk_overallocate upload_size daemon_sftp daemon_listen]a

  @derive {Jason.Encoder, only: @mandatory}

  @primary_key false
  embedded_schema do
    field(:name, :string)
    field(:location_id, :integer)
    field(:fqdn, :string)
    field(:scheme, :string)
    field(:memory, :integer)
    field(:memory_overallocate, :integer)
    field(:disk, :integer)
    field(:disk_overallocate, :integer)
    field(:upload_size, :integer)
    field(:daemon_sftp, :integer)
    field(:daemon_listen, :integer)
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.validate_length(:name, min: 1, max: 255)
    |> Changeset.validate_length(:fqdn, min: 1, max: 255)
    |> Changeset.validate_length(:scheme, min: 1, max: 255)
    |> Changeset.validate_number(:location_id, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:disk, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:disk_overallocate, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:memory, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:memory_overallocate, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:upload_size, greater_than_or_equal_to: 0)
  end
end
