defmodule Elidactyl.Application.ServerTest do
  use ExUnit.Case, async: false
  use Elidactyl.RequestCase

  alias Elidactyl.MockedServer
  alias Elidactyl.Application.Servers

  setup do
    %{attributes: server1} = MockedServer.put(:server, external_id: "RemoteId1")
    %{attributes: server2} = MockedServer.put(:server, external_id: "RemoteId2")
    %{attributes: db1} = MockedServer.put(:database, server: server1.id)
    %{attributes: db2} = MockedServer.put(:database, server: server1.id)
    %{attributes: db3} = MockedServer.put(:database, server: server2.id)
    %{server1: server1, server2: server2, db1: db1, db2: db2, db3: db3}
  end

  describe "list_servers/0" do
    test "lists servers", %{server1: server1, server2: server2, db1: db1, db2: db2, db3: db3} do
      assert {:ok, servers} = Servers.list_servers()
      assert length(servers) == 2
      s1 = Enum.find(servers, & &1.id == server1.id)
      s2 = Enum.find(servers, & &1.id == server2.id)
      assert s1 != nil
      assert s2 != nil
      assert length(s1.databases) == 2
      assert length(s2.databases) == 1
      assert Enum.any?(s1.databases, & &1.id == db1.id)
      assert Enum.any?(s1.databases, & &1.id == db2.id)
      assert Enum.any?(s2.databases, & &1.id == db3.id)
    end
  end

  describe "get_server_by_id/1" do
    test "gets server by id", %{server1: server} do
      assert {:ok, server} = Servers.get_server_by_id(server.id)
      assert server.external_id == "RemoteId1"
    end
  end

  describe "create_server/2" do
    test "creates server" do
      params = %{
        user: 1,
        egg: 15,
        docker_image: "quay.io/pterodactyl/core:java-glibc",
        startup: "java -Xms128M -Xmx 1024M -jar server.jar",
        environment: %{"DL_VERSION" => "1.12.2"},
        limits: %{memory: 512, swap: 0, disk: 1024, io: 500, cpu: 100},
        feature_limits: %{databases: 1, backups: 1},
        allocation: %{default: 28, additional: [3, 19]}
      }

      assert {:ok, %{id: id} = server} = Servers.create_server(params)
      assert %{
        allocation: allocation,
        container: %{
          environment: %{"DL_VERSION" => "1.12.2"},
          image: "quay.io/pterodactyl/core:java-glibc",
          installed: false,
          startup_command: "java -Xms128M -Xmx 1024M -jar server.jar"
        },
        egg: egg,
        feature_limits: %{backups: 1, databases: 1},
        id: ^id,
        limits: %{cpu: 100, disk: 1024, io: 500, memory: 512, swap: 0, threads: nil},
      } = server
      assert is_integer(allocation)
      assert is_integer(egg)
    end
  end

  describe "update_server_details/2" do
    test "updates server details", %{server1: %{id: id}} do
      params = %{
        name: "Gaming",
        user: 1,
        external_id: "RemoteID1",
        description: "Matt from Wii Sports"
      }

      assert {:ok, server} = Servers.update_server_details(id, params)
      assert server.name == "Gaming"
      assert server.user == 1
      assert server.external_id == "RemoteID1"
      assert server.description == "Matt from Wii Sports"
    end
  end

  describe "update_server_build_info/2" do
    test "updates server build info", %{server1: %{id: id}} do
      params = %{
        allocation: 1,
        memory: 512,
        swap: 0,
        disk: 200,
        io: 500,
        cpu: 0,
        threads: nil,
        feature_limits: %{databases: 5, allocations: 5, backups: 2},
      }

      assert {:ok, server} = Servers.update_server_build_info(id, params)
      assert server.feature_limits == %{databases: 5, allocations: 5, backups: 2}
      assert server.limits == %{memory: 512, swap: 0, disk: 200, io: 500, cpu: 0, threads: nil}
      assert server.allocation == 1
    end
  end

  describe "update_server_startup/2" do
    test "update server startup info", %{server1: %{id: id}} do
      params = %{
        startup: "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
        environment: %{"SERVER_JARFILE" => "server.jar", "VANILLA_VERSION" => "latest"},
        egg: 5,
        image: "quay.io/pterodactyl/core:java",
        skip_scripts: false
      }

      assert {:ok, server} = Servers.update_server_startup(id, params)
      assert %{
        startup_command: "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
        environment: %{"SERVER_JARFILE" => "server.jar", "VANILLA_VERSION" => "latest"},
        image: "quay.io/pterodactyl/core:java"
      } = server.container
      assert server.egg == 5
    end
  end

  describe "delete_server/2" do
    test "deletes server", %{server1: %{id: id1}, server2: %{id: id2}} do
      assert :ok = Servers.delete_server(id1)
      assert :ok = Servers.delete_server(id2, true)
    end
  end

  describe "suspend_server/1" do
    test "suspends server", %{server1: %{id: id}} do
      assert :ok = Servers.suspend_server(id)
    end
  end

  describe "unsuspend_server/1" do
    test "unsuspends server", %{server1: %{id: id}} do
      assert :ok = Servers.unsuspend_server(id)
    end
  end

  describe "reinstall_server/1" do
    test "reinstalls server", %{server1: %{id: id}} do
      assert :ok = Servers.reinstall_server(id)
    end
  end
end
