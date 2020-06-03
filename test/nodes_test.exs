defmodule Elidactyl.NodesTest do
  use ExUnit.Case
  alias Elidactyl.Nodes
  alias Elidactyl.Schemas.Node.Allocation

  test "list allocations for a node" do
    assert {:ok, allocations} = Nodes.list_allocations(1)
    assert [
             %Allocation{
               alias: "steam",
               assigned: false,
               id: 1,
               ip: "1.2.3.4",
               port: 1000
             },
             %Allocation{
               alias: "rcon",
               assigned: false,
               id: 2,
               ip: "1.2.3.4",
               port: 2000
             }
           ] == allocations
  end
end