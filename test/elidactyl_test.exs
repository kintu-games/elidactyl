defmodule ElidactylTest do
  use ExUnit.Case
  doctest Elidactyl, except: [create_server: 1]

  alias Elidactyl.MockedServer

  setup do
    MockedServer.put(:server,
      id: 5,
      allocation: 1,
      container: %{
        environment: %{
          "P_SERVER_LOCATION" => "Test",
          "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
          "SERVER_JARFILE" => "server.jar",
          "STARTUP" => "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
          "VANILLA_VERSION" => "latest"
        },
        image: "quay.io/pterodactyl/core:java",
        installed: true,
        startup_command: "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
      },
      created_at: "2019-12-23T06:46:27+00:00",
      description: "Matt from Wii Sports",
      egg: 5,
      external_id: "RemoteId1",
      feature_limits: %{allocations: 5, databases: 5, backups: 2},
      id: 5,
      identifier: "1a7ce997",
      limits: %{cpu: 0, disk: 200, io: 500, memory: 512, swap: 0, threads: nil},
      name: "Wuhu Island",
      nest: 1,
      node: 1,
      pack: nil,
      server_owner: nil,
      suspended: false,
      updated_at: "2020-06-13T04:20:53+00:00",
      user: 1,
      uuid: "1a7ce997-259b-452e-8b4e-cecc464142ca"
    )
    MockedServer.put(:database,
      created_at: "2020-06-12T23:00:20+01:00",
      database: "s5_coreprotect",
      host: 4,
      id: 2,
      max_connections: 0,
      remote: "%",
      server: 5,
      updated_at: "2020-06-12T23:00:20+01:00",
      username: "u5_2jtJx1nO1d"
    )
    MockedServer.put(:database,
      created_at: "2020-06-12T23:00:13+01:00",
      database: "s5_perms",
      host: 4,
      id: 1,
      max_connections: 0,
      remote: "%",
      server: 5,
      updated_at: "2020-06-12T23:00:13+01:00",
      username: "u5_QsIAp1jhvS"
    )
    :ok
  end
end
