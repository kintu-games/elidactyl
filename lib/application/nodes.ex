defmodule Elidactyl.Application.Nodes do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Error
  alias Elidactyl.Schemas.Node
  alias Elidactyl.Schemas.Node.CreateNodeParams
  alias Elidactyl.Schemas.Node.Allocation
  alias Elidactyl.Response

  @spec list_allocations(Elidactyl.id()) :: {:ok, [Allocation.t()]} | {:error, Error.t()}
  def list_allocations(node_id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/nodes/#{node_id}/allocations"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec get_configuration(Elidactyl.id()) :: {:ok, map} | {:error, Error.t()}
  def get_configuration(node_id) do
    Request.request(:get, "/api/application/nodes/#{node_id}/configuration")
  end

  @spec get(Elidactyl.id()) :: {:ok, Node.t()} | {:error, Error.t()}
  def get(node_id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/nodes/#{node_id}"),
         %Node{} = node <- Response.parse_response(resp) do
      {:ok, node}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec list() :: {:ok, [Node.t()]} | {:error, Error.t()}
  def list do
    with {:ok, resp} <- Request.request(:get, "/api/application/nodes"),
         nodes when is_list(nodes) <- Response.parse_response(resp) do
      {:ok, nodes}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec create_node(Elidactyl.params()) :: {:ok, Node.t()} | {:error, Error.t()}
  def create_node(params) do
    with %{valid?: true} = changeset <- CreateNodeParams.changeset(%CreateNodeParams{}, params),
         %CreateNodeParams{} = node <- Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:post, "/api/application/nodes", node),
         %Node{} = node <- Response.parse_response(resp) do
      {:ok, node}
    else
      {:error, _} = error -> error
      %Ecto.Changeset{} = changeset -> {:error, Error.from_changeset(changeset)}
      _ -> {:error, Error.invalid_response()}
    end
  end
end
