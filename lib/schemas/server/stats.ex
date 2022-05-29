defmodule Elidactyl.Schemas.Server.Stats do
  @moduledoc false

  use Ecto.Schema

  alias Elidactyl.Utils

  defmodule Resources do
    @moduledoc false
    @type t :: %{
            memory_bytes: integer | nil,
            cpu_absolute: integer | nil,
            disk_bytes: integer | nil,
            network_rx_bytes: integer | nil,
            network_tx_bytes: integer | nil
          }
    defstruct [:memory_bytes, :cpu_absolute, :disk_bytes, :network_rx_bytes, :network_tx_bytes]
  end

  @type t :: %__MODULE__{
          current_state: binary | nil,
          is_suspended: boolean | nil,
          is_installing: boolean | nil,
          resources: Resources.t() | nil
        }

  @primary_key false
  embedded_schema do
    field(:current_state, :binary)
    field(:is_suspended, :boolean)
    field(:is_installing, :boolean)

    embeds_one(:resources, Resources)
  end

  @spec parse(map) :: t()
  def parse(%{"object" => "stats", "attributes" => attributes}) do
    struct(__MODULE__, attributes |> Utils.keys_to_atoms() |> Utils.parse_timestamps())
  end
end
