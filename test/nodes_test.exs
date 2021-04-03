defmodule Elidactyl.NodesTest do
  use ExUnit.Case, async: false
  use Elidactyl.RequestCase

  alias Elidactyl.MockedServer
  alias Elidactyl.Nodes
  alias Elidactyl.Schemas.Node
  alias Elidactyl.Schemas.Node.Allocation

  setup do
    %{attributes: node1} = MockedServer.put(:node)
    %{attributes: node2} = MockedServer.put(:node)
    %{attributes: a1} = MockedServer.put(:allocation, node: node1.id)
    %{attributes: a2} = MockedServer.put(:allocation, node: node1.id)
    %{attributes: a3} = MockedServer.put(:allocation, node: node2.id)
    %{node1: node1, node2: node2, a1: a1, a2: a2, a3: a3}
  end

  describe "list_allocations/1" do
    test "lists allocations for a node", %{node1: node, a1: a1, a2: a2} do
      assert {:ok, allocations} = Nodes.list_allocations(node.id)
      assert length(allocations) == 2
      assert Enum.all?(allocations, & match?(%Allocation{}, &1))
      assert Enum.any?(allocations, & Map.drop(Map.from_struct(&1), ~w[__meta__]a) == Map.drop(a1, ~w[node]a))
      assert Enum.any?(allocations, & Map.drop(Map.from_struct(&1), ~w[__meta__]a) == Map.drop(a2, ~w[node]a))
    end
  end

  describe "get_configuration/1" do
    test "gets node configuration", %{node1: node} do
      assert {:ok, configuration} = Nodes.get_configuration(node.id)
      assert node.configuration == configuration
    end
  end

  describe "get/1" do
    test "gets node", %{node1: node} do
      assert {:ok, %Node{} = n} = Nodes.get(node.id)
      assert Map.drop(Map.from_struct(n), ~w[__meta__ created_at updated_at]a) ==
        Map.drop(node, ~w[created_at updated_at configuration]a)
    end
  end

  describe "list/0" do
    test "gets nodes list", %{node1: node1, node2: node2} do
      assert {:ok, nodes} = Nodes.list()
      assert length(nodes) == 2
      assert Enum.all?(nodes, & match?(%Node{}, &1))
      assert Enum.find(nodes, & &1.id == node1.id)
      assert Enum.find(nodes, & &1.id == node2.id)
    end
  end
end
