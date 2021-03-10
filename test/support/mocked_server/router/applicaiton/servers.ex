defmodule Elidactyl.MockedServer.Router.Application.Servers do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/api/application/servers" do
    body = %{
      "object" => "list",
      "data" => [
        %{
          "object" => "server",
          "attributes" => %{
            "id" => 5,
            "external_id" => "RemoteId1",
            "uuid" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
            "identifier" => "1a7ce997",
            "name" => "Wuhu Island",
            "description" => "Matt from Wii Sports",
            "suspended" => false,
            "limits" => %{
              "memory" => 512,
              "swap" => 0,
              "disk" => 200,
              "io" => 500,
              "cpu" => 0,
              "threads" => nil
            },
            "feature_limits" => %{
              "databases" => 5,
              "allocations" => 5,
              "backups" => 2
            },
            "user" => 1,
            "node" => 1,
            "allocation" => 1,
            "nest" => 1,
            "egg" => 5,
            "pack" => nil,
            "container" => %{
              "startup_command" => "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
              "image" => "quay.io\/pterodactyl\/core:java",
              "installed" => true,
              "environment" => %{
                "SERVER_JARFILE" => "server.jar",
                "VANILLA_VERSION" => "latest",
                "STARTUP" => "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
                "P_SERVER_LOCATION" => "Test",
                "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca"
              }
            },
            "updated_at" => "2020-06-13T04:20:53+00:00",
            "created_at" => "2019-12-23T06:46:27+00:00",
            "relationships" => %{
              "databases" => %{
                "object" => "list",
                "data" => [
                  %{
                    "object" => "databases",
                    "attributes" => %{
                      "id" => 1,
                      "server" => 5,
                      "host" => 4,
                      "database" => "s5_perms",
                      "username" => "u5_QsIAp1jhvS",
                      "remote" => "%",
                      "max_connections" => 0,
                      "created_at" => "2020-06-12T23:00:13+01:00",
                      "updated_at" => "2020-06-12T23:00:13+01:00"
                    }
                  },
                  %{
                    "object" => "databases",
                    "attributes" => %{
                      "id" => 2,
                      "server" => 5,
                      "host" => 4,
                      "database" => "s5_coreprotect",
                      "username" => "u5_2jtJx1nO1d",
                      "remote" => "%",
                      "max_connections" => 0,
                      "created_at" => "2020-06-12T23:00:20+01:00",
                      "updated_at" => "2020-06-12T23:00:20+01:00"
                    }
                  }
                ]
              }
            }
          }
        }
      ],
      "meta" => %{
        "pagination" => %{
          "total" => 1,
          "count" => 1,
          "per_page" => 50,
          "current_page" => 1,
          "total_pages" => 1,
          "links" => %{}
        }
      }
    }
    success(conn, body)
  end

  get "/api/application/servers/:id" do
    body = %{
      object: "server",
      attributes: %{
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
    }

    success(conn, body)
  end

  get "/api/application/servers/external/:external_id" do
    body = %{
      "object" => "server",
      "attributes" => %{
        "id" => 5,
        "external_id" => "RemoteId1",
        "uuid" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
        "identifier" => "1a7ce997",
        "name" => "Gaming",
        "description" => "Matt from Wii Sports",
        "suspended" => false,
        "limits" => %{
          "memory" => 512,
          "swap" => 0,
          "disk" => 200,
          "io" => 500,
          "cpu" => 0,
          "threads" => nil
        },
        "feature_limits" => %{
          "databases" => 5,
          "allocations" => 5,
          "backups" => 2
        },
        "user" => 1,
        "node" => 1,
        "allocation" => 1,
        "nest" => 1,
        "egg" => 5,
        "pack" => nil,
        "container" => %{
          "startup_command" => "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
          "image" => "quay.io\/pterodactyl\/core =>java",
          "installed" => true,
          "environment" => %{
            "SERVER_JARFILE" => "server.jar",
            "VANILLA_VERSION" => "latest",
            "STARTUP" => "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
            "P_SERVER_LOCATION" => "GB",
            "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
            "P_SERVER_ALLOCATION_LIMIT" => 5
          }
        },
        "updated_at" => "2020-07-19T15:22:39+00:00",
        "created_at" => "2019-12-23T06:46:27+00:00"
      }
    }

    success(conn, body)
  end

  post "/api/application/servers" do
    server = %{
      "object" => "server",
      "attributes" => %{
        "id" => 7,
        "external_id" => nil,
        "uuid" => "d557c19c-8b21-4456-a9e5-181beda429f4",
        "identifier" => "d557c19c",
        "name" => "Building",
        "description" => "",
        "suspended" => false,
        "limits" => %{
          "memory" => 128,
          "swap" => 0,
          "disk" => 512,
          "io" => 500,
          "cpu" => 100,
          "threads" => nil
        },
        "feature_limits" => %{
          "databases" => 5,
          "allocations" => 0,
          "backups" => 1
        },
        "user" => 1,
        "node" => 1,
        "allocation" => 17,
        "nest" => 1,
        "egg" => 1,
        "container" => %{
          "startup_command" => "java -Xms128M -Xmx128M -jar server.jar",
          "image" => "quay.io\/pterodactyl\/core =>java",
          "installed" => false,
          "environment" => %{
            "BUNGEE_VERSION" => "latest",
            "SERVER_JARFILE" => "server.jar",
            "STARTUP" => "java -Xms128M -Xmx128M -jar server.jar",
            "P_SERVER_LOCATION" => "GB",
            "P_SERVER_UUID" => "d557c19c-8b21-4456-a9e5-181beda429f4",
            "P_SERVER_ALLOCATION_LIMIT" => 0
          }
        },
        "updated_at" => "2020-10-29T01:38:59+00:00",
        "created_at" => "2020-10-29T01:38:59+00:00"
      }
    }

    success(conn, server)
  end

  patch "/api/application/servers/:id/details" do
    server = %{
      "object" => "server",
      "attributes" => %{
        "id" => 5,
        "external_id" => "RemoteID1",
        "uuid" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
        "identifier" => "1a7ce997",
        "name" => "Gaming",
        "description" => "Matt from Wii Sports",
        "suspended" => false,
        "limits" => %{
          "memory" => 512,
          "swap" => 0,
          "disk" => 200,
          "io" => 500,
          "cpu" => 0,
          "threads" => nil
        },
        "feature_limits" => %{
          "databases" => 5,
          "allocations" => 5,
          "backups" => 2
        },
        "user" => 1,
        "node" => 1,
        "allocation" => 1,
        "nest" => 1,
        "egg" => 5,
        "container" => %{
          "startup_command" => "java -Xms128M -Xmx2014M -jar server.jar",
          "image" => "quay.io\/pterodactyl\/core:java",
          "installed" => true,
          "environment" => %{
            "SERVER_JARFILE" => "server.jar",
            "VANILLA_VERSION" => "latest",
            "STARTUP" => "java -Xms128M -Xmx2048M -jar server.jar",
            "P_SERVER_LOCATION" => "GB",
            "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
            "P_SERVER_ALLOCATION_LIMIT" => 5
          }
        },
        "updated_at" => "2020-11-04T21:11:26+00:00",
        "created_at" => "2019-12-23T06:46:27+00:00"
      }
    }

    success(conn, server)
  end

  delete "/api/application/servers/:id" do
    success(conn, "", 204)
  end

  patch "/api/application/servers/:id/build" do
    server = %{
      "object" => "server",
      "attributes" => %{
        "id" => 5,
        "external_id" => "RemoteID1",
        "uuid" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
        "identifier" => "1a7ce997",
        "name" => "Gaming",
        "description" => "Matt from Wii Sports",
        "suspended" => false,
        "limits" => %{
          "memory" => 512,
          "swap" => 0,
          "disk" => 200,
          "io" => 500,
          "cpu" => 0,
          "threads" => nil
        },
        "feature_limits" => %{
          "databases" => 5,
          "allocations" => 5,
          "backups" => 2
        },
        "user" => 1,
        "node" => 1,
        "allocation" => 1,
        "nest" => 1,
        "egg" => 5,
        "container" => %{
          "startup_command" => "java -Xms128M -Xmx2014M -jar server.jar",
          "image" => "quay.io\/pterodactyl\/core:java",
          "installed" => true,
          "environment" => %{
            "SERVER_JARFILE" => "server.jar",
            "VANILLA_VERSION" => "latest",
            "STARTUP" => "java -Xms128M -Xmx2048M -jar server.jar",
            "P_SERVER_LOCATION" => "GB",
            "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
            "P_SERVER_ALLOCATION_LIMIT" => 5
          }
        },
        "updated_at" => "2020-11-04T21:11:26+00:00",
        "created_at" => "2019-12-23T06:46:27+00:00"
      }
    }

    success(conn, server)
  end

  patch "/api/application/servers/:id/startup" do
    server = %{
      "object" => "server",
      "attributes" => %{
        "id" => 5,
        "external_id" => "RemoteID1",
        "uuid" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
        "identifier" => "1a7ce997",
        "name" => "Gaming",
        "description" => "Matt from Wii Sports",
        "suspended" => false,
        "limits" => %{
          "memory" => 512,
          "swap" => 0,
          "disk" => 200,
          "io" => 500,
          "cpu" => 0,
          "threads" => nil
        },
        "feature_limits" => %{
          "databases" => 5,
          "allocations" => 5,
          "backups" => 2
        },
        "user" => 1,
        "node" => 1,
        "allocation" => 1,
        "nest" => 1,
        "egg" => 5,
        "container" => %{
          "startup_command" => "java -Xms128M -Xmx2014M -jar server.jar",
          "image" => "quay.io\/pterodactyl\/core:java",
          "installed" => true,
          "environment" => %{
            "SERVER_JARFILE" => "server.jar",
            "VANILLA_VERSION" => "latest",
            "STARTUP" => "java -Xms128M -Xmx2048M -jar server.jar",
            "P_SERVER_LOCATION" => "GB",
            "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
            "P_SERVER_ALLOCATION_LIMIT" => 5
          }
        },
        "updated_at" => "2020-11-04T21:11:26+00:00",
        "created_at" => "2019-12-23T06:46:27+00:00"
      }
    }

    success(conn, server)
  end
end
