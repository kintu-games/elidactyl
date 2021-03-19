defmodule Elidactyl.Application.NestsTest do
  use ExUnit.Case, async: false
  use Elidactyl.RequestCase

  alias Elidactyl.MockedServer
  alias Elidactyl.Application.Nests

  describe "eggs_list/2" do
    setup do
      %{attributes: nest} = MockedServer.put(:nest)
      %{attributes: egg1} = MockedServer.put(:egg, nest: nest.id)
      %{attributes: egg2} = MockedServer.put(:egg, nest: nest.id)
      %{attributes: server} = MockedServer.put(:server, nest: nest.id, egg: egg1.id)
      %{attributes: var} = MockedServer.put(:egg_variable, egg_id: egg1.id)
      %{nest: nest, egg1: egg1, egg2: egg2, server: server, var: var}
    end

    test "lists eggs", %{nest: nest, egg1: egg1, egg2: egg2} do
      assert {:ok, eggs} = Nests.list_eggs(nest.id)
      assert length(eggs) == 2
      assert Enum.any?(eggs, & &1.id == egg1.id)
      assert Enum.any?(eggs, & &1.id == egg2.id)
      assert Enum.all?(eggs, & is_nil(&1.nest) and is_nil(&1.servers))
    end

    test "list eggs with nest included", %{nest: %{id: nest_id}} do
      assert {:ok, [%{nest: %{id: ^nest_id}} | _]} = Nests.list_eggs(nest_id, [:nest])
    end

    test "list eggs with servers included", %{server: %{id: server_id}, nest: nest, egg1: egg1, egg2: egg2} do
      {:ok, eggs} = Nests.list_eggs(nest.id, [:servers])
      assert [%{id: ^server_id}] = Enum.find(eggs, & &1.id == egg1.id).servers
      assert [] = Enum.find(eggs, & &1.id == egg2.id).servers
    end

    test "list eggs with variables included", %{var: %{id: var_id}, nest: nest, egg1: egg1, egg2: egg2} do
      {:ok, eggs} = Nests.list_eggs(nest.id, [:variables])
      assert [%{id: ^var_id}] = Enum.find(eggs, & &1.id == egg1.id).variables
      assert [] = Enum.find(eggs, & &1.id == egg2.id).variables
    end

    test "list eggs with all relationships included", %{nest: nest} do
      {:ok, eggs} = Nests.list_eggs(nest.id, [:nest, :servers, :variables])
      assert Enum.all?(eggs, & not is_nil(&1.nest) and not is_nil(&1.servers) and not is_nil(&1.variables))
    end
  end
end
