defmodule Elidactyl.MockedServer.Router.Application.Nodes do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  alias Elidactyl.MockedServer
  alias Elidactyl.MockedServer.ExternalSchema.NullResource

  plug Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Jason
  plug :match
  plug :dispatch

  get "/api/application/nodes/:id/allocations" do
    {id, ""} = Integer.parse(id)
    case MockedServer.get(:node, id) do
      %NullResource{} ->
        failure(conn, 404, "not found node #{id}")

      _node ->
        %{data: allocations} = list = MockedServer.list(:allocation)
        allocations =
          allocations
          |> Enum.filter(& match?(%{attributes: %{node: ^id}}, &1))
          |> Enum.map(&serialize_allocation/1)
        success(conn, %{list | data: allocations})
    end
  end

  get "/api/application/nodes/:id/configuration" do
    {id, ""} = Integer.parse(id)
    case MockedServer.get(:node, id) do
      %NullResource{} ->
        failure(conn, 404, "not found node #{id}")

      node ->
        success(conn, node.attributes.configuration)
    end
  end

  get "/api/application/nodes/:id" do
    {id, ""} = Integer.parse(id)
    case MockedServer.get(:node, id) do
      %NullResource{} ->
        failure(conn, 404, "not found node #{id}")

      node ->
        success(conn, serialize(node))
    end
  end

  get "/api/application/nodes" do
    %{data: nodes} = list = MockedServer.list(:node)
    nodes = nodes |> Enum.map(&serialize/1)
    meta = %{
      pagination: %{
        total: length(nodes),
        count: length(nodes),
        per_page: 50,
        current_page: 1,
        total_pages: 1,
        links: %{}
      }
    }
    success(conn, %{list | data: nodes, meta: meta})
  end

  defp serialize(node), do: %{node | attributes: Map.drop(node.attributes, ~w[configuration]a)}
  defp serialize_allocation(allocation), do: %{allocation | attributes: Map.drop(allocation.attributes, ~w[node]a)}
end
