defmodule Elidactyl.Schemas.Node do
  @moduledoc false

  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  @type t :: %__MODULE__{
          id: non_neg_integer | nil,
          uuid: Ecto.UUID.t() | nil,
          public: boolean | nil,
          name: binary | nil,
          description: binary | nil,
          location_id: non_neg_integer | nil,
          fqdn: binary | nil,
          scheme: binary | nil,
          behind_proxy: boolean | nil,
          maintenance_mode: boolean | nil,
          memory: integer | nil,
          memory_overallocate: integer | nil,
          disk: integer | nil,
          disk_overallocate: integer | nil,
          upload_size: integer | nil,
          daemon_listen: integer | nil,
          daemon_sftp: integer | nil,
          daemon_base: binary | nil,
          created_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  defstruct ~w[
    id uuid public name description location_id fqdn scheme behind_proxy maintenance_mode
    memory memory_overallocate disk disk_overallocate upload_size
    daemon_listen daemon_sftp daemon_base created_at updated_at
  ]a

  @impl Parser
  def parse(%{"object" => "node", "attributes" => attributes}) do
    struct(__MODULE__, attributes |> Utils.keys_to_atoms() |> Utils.parse_timestamps())
  end
end
