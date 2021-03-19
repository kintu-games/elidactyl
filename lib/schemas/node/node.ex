defmodule Elidactyl.Schemas.Node do
  @moduledoc false

  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  defstruct ~w[
    id uuid public name description location_id fqdn scheme behind_proxy maintenance_mode
    memory memory_overallocate disk disk_overallocate upload_size
    daemon_listen daemon_sftp daemon_base created_at updated_at]a

  @type t :: %__MODULE__{}

  @impl Parser
  def parse(%{"object" => "node", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
