defmodule Elidactyl.ServerTest do
  use ExUnit.Case

  alias Elidactyl.Application.Servers
  alias Elidactyl.Schemas.Server
  alias Elidactyl.Schemas.Server.Database

  test "list servers" do
    assert {:ok, users} = Servers.list_servers()
    assert [
             %Server{
               id: 5,
               external_id: "RemoteId1",
               uuid: "1a7ce997-259b-452e-8b4e-cecc464142ca",
               identifier: "1a7ce997",
               name: "Wuhu Island",
               description: "Matt from Wii Sports",
               suspended: false,
               limits: %{
                 memory: 512,
                 swap: 0,
                 disk: 200,
                 io: 500,
                 cpu: 0,
                 threads: nil
               },
               feature_limits: %{
                 databases: 5,
                 allocations: 5,
                 backups: 2
               },
               user: 1,
               node: 1,
               allocation: 1,
               nest: 1,
               egg: 5,
               pack: nil,
               container: %{
                 startup_command: "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
                 image: "quay.io\/pterodactyl\/core:java",
                 installed: true,
                 environment: %{
                   "SERVER_JARFILE" => "server.jar",
                   "VANILLA_VERSION" => "latest",
                   "STARTUP" => "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
                   "P_SERVER_LOCATION" => "Test",
                   "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca"
                 }
               },
               updated_at: "2020-06-13T04:20:53+00:00",
               created_at: "2019-12-23T06:46:27+00:00",
               databases: [
                 %Database{
                   id: 1,
                   server: 5,
                   host: 4,
                   database: "s5_perms",
                   username: "u5_QsIAp1jhvS",
                   remote: "%",
                   max_connections: 0,
                   created_at: "2020-06-12T23:00:13+01:00",
                   updated_at: "2020-06-12T23:00:13+01:00"
                 },
                 %Database{
                   id: 2,
                   server: 5,
                   host: 4,
                   database: "s5_coreprotect",
                   username: "u5_2jtJx1nO1d",
                   remote: "%",
                   max_connections: 0,
                   created_at: "2020-06-12T23:00:20+01:00",
                   updated_at: "2020-06-12T23:00:20+01:00"
                 }
               ]

             }
           ] == users
  end

  test "get server by id" do
    assert {:ok, server} = Servers.get_server_by_id(1)

    assert %Server{
             id: 5,
             external_id: "RemoteId1",
             uuid: "1a7ce997-259b-452e-8b4e-cecc464142ca",
             identifier: "1a7ce997",
             name: "Gaming",
             description: "Matt from Wii Sports",
             suspended: false,
             limits: %{
               memory: 512,
               swap: 0,
               disk: 200,
               io: 500,
               cpu: 0,
               threads: nil
             },
             feature_limits: %{
               databases: 5,
               allocations: 5,
               backups: 2
             },
             user: 1,
             node: 1,
             allocation: 1,
             nest: 1,
             egg: 5,
             pack: nil,
             container: %{
               startup_command: "java -Xms128M -Xmx2014M -jar server.jar",
               image: "quay.io\/pterodactyl\/core:java",
               installed: true,
               environment: %{
                 "SERVER_JARFILE" => "server.jar",
                 "VANILLA_VERSION" => "latest",
                 "STARTUP" => "java -Xms128M -Xmx2014M -jar server.jar",
                 "P_SERVER_LOCATION" => "GB",
                 "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
                 "P_SERVER_ALLOCATION_LIMIT" => 5
               }
             },
             updated_at: "2020-11-04T21:11:26+00:00",
             created_at: "2019-12-23T06:46:27+00:00"
           }
           == server
  end

  test "create server" do
    params = %{
      user: 1,
      egg: 15,
      docker_image: "quay.io/pterodactyl/core:java-glibc",
      startup: "java -Xms128M -Xmx 1024M -jar server.jar",
      environment: %{
        "DL_VERSION" => "1.12.2"
      },
      limits: %{
        memory: 512,
        swap: 0,
        disk: 1024,
        io: 500,
        cpu: 100
      },
      feature_limits: %{
        databases: 1,
        backups: 1
      },
      allocation: %{
        default: 28,
        additional: [3, 19]
      }
    }
    assert {:ok, server} = Servers.create_server(params)

    assert server == %Server{
             allocation: 17,
             container: %{
               environment: %{
                 "BUNGEE_VERSION" => "latest",
                 "P_SERVER_ALLOCATION_LIMIT" => 0,
                 "P_SERVER_LOCATION" => "GB",
                 "P_SERVER_UUID" => "d557c19c-8b21-4456-a9e5-181beda429f4",
                 "SERVER_JARFILE" => "server.jar",
                 "STARTUP" => "java -Xms128M -Xmx128M -jar server.jar"
               },
               image: "quay.io/pterodactyl/core =>java",
               installed: false,
               startup_command: "java -Xms128M -Xmx128M -jar server.jar"
             },
             created_at: "2020-10-29T01:38:59+00:00",
             databases: [],
             description: "",
             egg: 1,
             external_id: nil,
             feature_limits: %{allocations: 0, backups: 1, databases: 5},
             id: 7,
             identifier: "d557c19c",
             limits: %{cpu: 100, disk: 512, io: 500, memory: 128, swap: 0, threads: nil},
             name: "Building",
             nest: 1,
             node: 1,
             pack: nil,
             server_owner: nil,
             suspended: false,
             updated_at: "2020-10-29T01:38:59+00:00",
             user: 1,
             uuid: "d557c19c-8b21-4456-a9e5-181beda429f4"
           }

  end

  test "update server details" do
    params = %{
      name: "Gaming",
      user: 1,
      external_id: "RemoteID1",
      description: "Matt from Wii Sports"
    }

    assert {:ok, server} = Servers.update_server_details(1, params)
    assert server == %Server{
             allocation: 1,
             container: %{
               environment: %{
                 "P_SERVER_ALLOCATION_LIMIT" => 5,
                 "P_SERVER_LOCATION" => "GB",
                 "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
                 "SERVER_JARFILE" => "server.jar",
                 "STARTUP" => "java -Xms128M -Xmx2048M -jar server.jar",
                 "VANILLA_VERSION" => "latest"
               },
               image: "quay.io/pterodactyl/core:java",
               installed: true,
               startup_command: "java -Xms128M -Xmx2014M -jar server.jar"
             },
             created_at: "2019-12-23T06:46:27+00:00",
             databases: [],
             description: "Matt from Wii Sports",
             egg: 5,
             external_id: "RemoteID1",
             feature_limits: %{allocations: 5, backups: 2, databases: 5},
             id: 5,
             identifier: "1a7ce997",
             limits: %{cpu: 0, disk: 200, io: 500, memory: 512, swap: 0, threads: nil},
             name: "Gaming",
             nest: 1,
             node: 1,
             pack: nil,
             server_owner: nil,
             suspended: false,
             updated_at: "2020-11-04T21:11:26+00:00",
             user: 1,
             uuid: "1a7ce997-259b-452e-8b4e-cecc464142ca"
           }


  end

  test "delete server" do
    assert :ok = Servers.delete_server(1)
  end

  test "update server build info" do
    params = %{
      allocation: 1,
      memory: 512,
      swap: 0,
      disk: 200,
      io: 500,
      cpu: 0,
      threads: nil,
      feature_limits: %{
        databases: 5,
        allocations: 5,
        backups: 2,
      },
    }

    assert {:ok, server} = Servers.update_server_build_info(1, params)
    assert server == %Server{
             id: 5,
             external_id: "RemoteID1",
             uuid: "1a7ce997-259b-452e-8b4e-cecc464142ca",
             identifier: "1a7ce997",
             name: "Gaming",
             description: "Matt from Wii Sports",
             suspended: false,
             limits: %{
               memory: 512,
               swap: 0,
               disk: 200,
               io: 500,
               cpu: 0,
               threads: nil,
             },
             feature_limits: %{
               databases: 5,
               allocations: 5,
               backups: 2,
             },
             user: 1,
             node: 1,
             allocation: 1,
             nest: 1,
             egg: 5,
             container: %{
               environment: %{
                 "P_SERVER_ALLOCATION_LIMIT" => 5,
                 "P_SERVER_LOCATION" => "GB",
                 "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
                 "SERVER_JARFILE" => "server.jar",
                 "STARTUP" => "java -Xms128M -Xmx2048M -jar server.jar",
                 "VANILLA_VERSION" => "latest"
               },
               image: "quay.io/pterodactyl/core:java",
               installed: true,
               startup_command: "java -Xms128M -Xmx2014M -jar server.jar"
             },
             updated_at: "2020-11-04T21:11:26+00:00",
             created_at: "2019-12-23T06:46:27+00:00",
           }
  end
end
