defmodule Elidactyl.ServerTest do
  use ExUnit.Case

  alias Elidactyl.Servers
  alias Elidactyl.Schemas.Server

  test "list users" do
    assert {:ok, users} = Servers.list_servers()
    assert [
             %Server{
               pack: nil,
               allocation: 3,
               container: %{
                 environment: %{
                   "P_SERVER_LOCATION" => "test",
                   "P_SERVER_UUID" => "47a7052b-f07e-4845-989d-e876e30960f4",
                   "SERVER_JARFILE" => "server.jar",
                   "STARTUP" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
                   "VANILLA_VERSION" => "latest"
                 },
                 image: "quay.io/pterodactyl/core:java",
                 installed: true,
                 startup_command: "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}"
               },
               created_at: "2018-09-29T22:50:16+00:00",
               description: "",
               egg: 4,
               feature_limits: %{
                 allocations: 0,
                 databases: 10
               },
               id: 2,
               identifier: "47a7052b",
               limits: %{
                 cpu: 300,
                 disk: 10000,
                 io: 500,
                 memory: 2048,
                 swap: -1
               },
               name: "Eat Vegies",
               nest: 1,
               node: 2,
               updated_at: "2018-11-20T14:35:00+00:00",
               user: 1,
               suspended: false,
               uuid: "47a7052b-f07e-4845-989d-e876e30960f4"
             },
             %Server{
               pack: nil,
               allocation: 4,
               container: %{
                 environment: %{
                   "P_SERVER_LOCATION" => "test",
                   "P_SERVER_UUID" => "6d1567c5-08d4-4ecb-8d5d-0ce1ba6b0b99",
                   "STARTUP" => "./parkertron"
                 },
                 image: "quay.io/parkervcp/pterodactyl-images:parkertron",
                 installed: true,
                 startup_command: "./parkertron"
               },
               created_at: "2018-11-10T19:51:23+00:00",
               description: "t",
               egg: 15,
               feature_limits: %{
                 allocations: 0,
                 databases: 0
               },
               id: 6,
               identifier: "6d1567c5",
               limits: %{
                 cpu: 200,
                 disk: 5000,
                 io: 500,
                 memory: 0,
                 swap: -1
               },
               name: "Wow",
               nest: 1,
               node: 2,
               updated_at: "2018-11-10T19:52:13+00:00",
               user: 5,
               suspended: false,
               uuid: "6d1567c5-08d4-4ecb-8d5d-0ce1ba6b0b99"
             }
           ] == users
  end

  test "get server by id" do
    assert {:ok, server} = Servers.get_server_by_id(1)

    %Server{
      pack: nil,
      allocation: 3,
      container: %{
        environment: %{
          "P_SERVER_LOCATION" => "test",
          "P_SERVER_UUID" => "47a7052b-f07e-4845-989d-e876e30960f4",
          "SERVER_JARFILE" => "server.jar",
          "STARTUP" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
          "VANILLA_VERSION" => "latest"
        },
        image: "quay.io/pterodactyl/core:java",
        installed: true,
        startup_command: "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}"
      },
      created_at: "2018-09-29T22:50:16+00:00",
      description: "",
      egg: 4,
      feature_limits: %{
        allocations: 0,
        databases: 10
      },
      id: 2,
      identifier: "47a7052b",
      limits: %{
        cpu: 300,
        disk: 10000,
        io: 500,
        memory: 2048,
        swap: -1
      },
      name: "Eat Vegies",
      nest: 1,
      node: 2,
      updated_at: "2018-11-20T14:35:00+00:00",
      user: 1,
      suspended: false,
      uuid: "47a7052b-f07e-4845-989d-e876e30960f4"
    } = server
  end

  test "get server by external id" do
    assert {:ok, server} = Servers.get_server_by_external_id(10)

    %Server{
      pack: nil,
      allocation: 3,
      container: %{
        environment: %{
          "P_SERVER_LOCATION" => "test",
          "P_SERVER_UUID" => "47a7052b-f07e-4845-989d-e876e30960f4",
          "SERVER_JARFILE" => "server.jar",
          "STARTUP" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
          "VANILLA_VERSION" => "latest"
        },
        image: "quay.io/pterodactyl/core:java",
        installed: true,
        startup_command: "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}"
      },
      created_at: "2018-09-29T22:50:16+00:00",
      description: "",
      egg: 4,
      feature_limits: %{
        allocations: 0,
        databases: 10
      },
      id: 2,
      external_id: 10,
      identifier: "47a7052b",
      limits: %{
        cpu: 300,
        disk: 10000,
        io: 500,
        memory: 2048,
        swap: -1
      },
      name: "Eat Vegies",
      nest: 1,
      node: 2,
      updated_at: "2018-11-20T14:35:00+00:00",
      user: 1,
      suspended: false,
      uuid: "47a7052b-f07e-4845-989d-e876e30960f4"
    } = server
  end

  test "create server" do
    params = %{
      user: 1,
      allocation: %{
        default: 28,
        additional: [3, 19]
      },
      startup: "java -Xms128M -Xmx 1024M -jar server.jar",
      docker_image: "quay.io/pterodactyl/core:java-glibc",
      environment: %{
        "DL_VERSION" => "1.12.2"
      },

      description: "Test server",
      egg: 15,
      external_id: "test_server",
      feature_limits: %{
        databases: 1,
        allocations: 2
      },
      limits: %{
        memory: 512,
        swap: 0,
        disk: 1024,
        io: 500,
        cpu: 100
      },
      name: "Test",
      pack: 1,
      deploy: %{
        locations: [1],
        dedicated_ip: false,
        port_range: []
      },

      start_on_completion: true,
      skip_scripts: false,
      oom_disabled: true
    }
    assert {:ok, server} = Servers.create_server(params)

    assert server ==
             %Server{
               server_owner: nil,
               allocation: 28,
               container: %{
                 environment: %{
                   "DL_VERSION" => "1.12.2",
                   "P_SERVER_LOCATION" => "fr.sys",
                   "P_SERVER_UUID" => "d7bcc254-e218-4522-a7fe-9d2d562ad790",
                   "STARTUP" => "java -Xms128M -Xmx 1024M -jar server.jar"
                 },
                 image: "quay.io/pterodactyl/core:java-glibc",
                 installed: false,
                 startup_command: "java -Xms128M -Xmx 1024M -jar server.jar"
               },
               created_at: "2019-02-23T11:25:35+00:00",
               description: "Test server",
               egg: 15,
               external_id: "test_server",
               feature_limits: %{
                 allocations: 2,
                 databases: 1
               },
               id: 53,
               identifier: "d7bcc254",
               limits: %{
                 cpu: 100,
                 disk: 1024,
                 io: 500,
                 memory: 512,
                 swap: 0
               },
               name: "Test",
               nest: 5,
               node: 1,
               pack: 1,
               suspended: false,
               updated_at: "2019-02-23T11:25:35+00:00",
               user: 1,
               uuid: "d7bcc254-e218-4522-a7fe-9d2d562ad790"
             }
  end

  test "update server details" do
    params = %{
      external_id: "some_id",
      name: "New name",
      user: "1",
      description: "New description"
    }

    assert {:ok, server} = Servers.update_server_details(1, params)
    assert server ==
             %Server{
               external_id: "some_id",
               name: "New name",
               user: 1,
               description: "New description",
               server_owner: nil,
               allocation: 28,
               container: %{
                 environment: %{
                   "DL_VERSION" => "1.12.2",
                   "P_SERVER_LOCATION" => "fr.sys",
                   "P_SERVER_UUID" => "d7bcc254-e218-4522-a7fe-9d2d562ad790",
                   "STARTUP" => "java -Xms128M -Xmx 1024M -jar server.jar"
                 },
                 image: "quay.io/pterodactyl/core:java-glibc",
                 installed: false,
                 startup_command: "java -Xms128M -Xmx 1024M -jar server.jar"
               },
               created_at: "2019-02-23T11:25:35+00:00",
               egg: 15,
               feature_limits: %{
                 allocations: 2,
                 databases: 1
               },
               id: 53,
               identifier: "d7bcc254",
               limits: %{
                 cpu: 100,
                 disk: 1024,
                 io: 500,
                 memory: 512,
                 swap: 0
               },
               nest: 5,
               node: 1,
               pack: 1,
               suspended: false,
               updated_at: "2019-02-23T11:25:35+00:00",
               uuid: "d7bcc254-e218-4522-a7fe-9d2d562ad790"
             }

  end

  test "delete server" do
    assert :ok = Servers.delete_server(1)
  end
end
