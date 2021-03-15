defmodule Elidactyl.Nodes do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Error
  alias Elidactyl.Schemas.Node.Allocation
  alias Elidactyl.Response

  @spec list_allocations(integer) :: {:ok, Allocation.t} | {:error, Error.t}
  def list_allocations(node_id) do
    # GET https://pterodactyl.app/api/application/nodes/<node_id>/allocations
    with {:ok, resp} <- Request.request(:get, "/api/application/nodes/#{node_id}/allocations"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    end
  end

  @spec get_configuration(integer) :: {:ok, map} | {:error, Error.t}
  def get_configuration(node_id) do
    Request.request(:get, "/api/application/nodes/#{node_id}/configuration")
  end
end
