defmodule Elidactyl.MockServer do
  use Plug.Router
  alias Elidactyl.MockServer.List
  alias Elidactyl.MockServer.User
  alias Elidactyl.MockServer.Server

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Poison
  )

  plug(:match)
  plug(:dispatch)

  get "/test" do
    success(conn, %{"type" => "get"})
  end

  post "/test" do
    success(conn, %{"type" => "post", "params" => conn.params})
  end

  put "/test" do
    success(conn, %{"type" => "put", "params" => conn.params})
  end

  patch "/test" do
    success(conn, %{"type" => "patch", "params" => conn.params})
  end

  delete "/test" do
    success(conn, %{"type" => "delete"})
  end

  get "/test_not_found" do
    failure(conn, 404)
  end

  get "/api/client" do
    servers = %{
      "data" => [
        %{
          "attributes" => %{
            "description" => "",
            "feature_limits" => %{
              "allocations" => 5,
              "databases" => 5
            },
            "identifier" => "d3aac109",
            "limits" => %{
              "cpu" => 200,
              "disk" => 5000,
              "io" => 500,
              "memory" => 1024,
              "swap" => 0
            },
            "name" => "Survival",
            "server_owner" => true,
            "uuid" => "d3aac109-e5a0-4331-b03e-3454f7e136dc"
          },
          "object" => "server"
        }
      ],
      "meta" => %{
        "pagination" => %{
          "count" => 1,
          "current_page" => 1,
          "links" => [],
          "per_page" => 25,
          "total" => 1,
          "total_pages" => 1
        }
      },
      "object" => "list"
    }

    success(conn, Poison.encode!(servers))
  end

  post "/api/client/servers/:id/power" do
    case conn.params do
      %{"signal" => "start"} ->
        success(conn, "")

      %{"signal" => "stop"} ->
        success(conn, "")

      _ ->
        failure(conn, 404)
    end
  end

  #============== USERS ================

  get "/api/application/users" do
    body = %List{
      object: "list",
      data: [
        %User{
          attributes: %{
            id: 1,
            external_id: nil,
            uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
            username: "codeco",
            email: "codeco@file.properties",
            first_name: "Rihan",
            last_name: "Arfan",
            language: "en",
            root_admin: true,
            "2fa": false,
            created_at: "2018-03-18T15:15:17+00:00",
            updated_at: "2018-10-16T21:51:21+00:00"
          }
        },
        %User{
          object: "user",
          attributes: %{
            id: 4,
            external_id: nil,
            uuid: "f253663c-5a45-43a8-b280-3ea3c752b931",
            username: "wardledeboss",
            email: "wardle315@gmail.com",
            first_name: "Harvey",
            last_name: "Wardle",
            language: "en",
            root_admin: false,
            "2fa": false,
            created_at: "2018-09-29T17:59:45+00:00",
            updated_at: "2018-10-02T18:59:03+00:00"
          }
        }
      ]
    }

    success(conn, body)
  end

  get "/api/application/users/:id" do
    body = %User{
      object: "user",
      attributes: %{
        id: id,
        external_id: nil,
        uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
        username: "codeco",
        email: "codeco@file.properties",
        first_name: "Rihan",
        last_name: "Arfan",
        language: "en",
        root_admin: true,
        "2fa": false,
        created_at: "2018-03-18T15:15:17+00:00",
        updated_at: "2018-10-16T21:51:21+00:00"
      }
    }

    success(conn, body)
  end

  get "/api/application/users/external/:external_id" do
    body = %User{
      object: "user",
      attributes: %{
        id: 1,
        external_id: external_id,
        uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
        username: "codeco",
        email: "codeco@file.properties",
        first_name: "Rihan",
        last_name: "Arfan",
        language: "en",
        root_admin: true,
        "2fa": false,
        created_at: "2018-03-18T15:15:17+00:00",
        updated_at: "2018-10-16T21:51:21+00:00"
      }
    }

    success(conn, body)
  end

  post "/api/application/users" do
    params = conn.params
    if Map.take(params, ["username", "email", "first_name", "last_name"])
       |> Kernel.map_size() == 4 do
      body = %User{
        object: "user",
        attributes:
          Map.merge(
            %{
              id: 2,
              uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
              "2fa": false,
              created_at: "2018-03-18T15:15:17+00:00",
              updated_at: "2018-10-16T21:51:21+00:00"
            },
            params
          )
      }
      success(conn, body, 201)
    else
      #      success(conn, "mandatory params missing in request #{inspect params}")
      failure(conn, 500, "mandatory params missing in request #{inspect params}")
    end
  end

  patch "/api/application/users/:id" do
    params = conn.params
    if Map.take(params, ["username", "email", "first_name", "last_name"])
       |> Kernel.map_size() == 4 do
      body = %User{
        object: "user",
        attributes:
          Map.merge(
            %{
              id: id,
              uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
              "2fa": false,
              created_at: "2018-03-18T15:15:17+00:00",
              updated_at: "2018-10-16T21:51:21+00:00"
            },
            params
          )
      }
      success(conn, body)
    else
      #      success(conn, "mandatory params missing in request #{inspect params}")
      failure(conn, 500, "mandatory params missing in request #{inspect params}")
    end
  end

  delete "/api/application/users/:id" do
    success(conn, "", 204)
  end

  #============== SERVERS ================

  get "/api/application/servers" do
    body =
      %List{
        object: "list",
        data: [
          %{
            "object" => "server",
            "attributes" => %{
              "id" => 2,
              "external_id" => nil,
              "uuid" => "47a7052b-f07e-4845-989d-e876e30960f4",
              "identifier" => "47a7052b",
              "name" => "Eat Vegies",
              "description" => "",
              "suspended" => false,
              "limits" => %{
                "memory" => 2048,
                "swap" => -1,
                "disk" => 10000,
                "io" => 500,
                "cpu" => 300
              },
              "feature_limits" => %{
                "databases" => 10,
                "allocations" => 0
              },
              "user" => 1,
              "node" => 2,
              "allocation" => 3,
              "nest" => 1,
              "egg" => 4,
              "pack" => nil,
              "container" => %{
                "startup_command" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
                "image" => "quay.io/pterodactyl/core:java",
                "installed" => true,
                "environment" => %{
                  "SERVER_JARFILE" => "server.jar",
                  "VANILLA_VERSION" => "latest",
                  "STARTUP" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
                  "P_SERVER_LOCATION" => "test",
                  "P_SERVER_UUID" => "47a7052b-f07e-4845-989d-e876e30960f4"
                }
              },
              "updated_at" => "2018-11-20T14:35:00+00:00",
              "created_at" => "2018-09-29T22:50:16+00:00"
            }
          },
          %{
            "object" => "server",
            "attributes" => %{
              "id" => 6,
              "external_id" => nil,
              "uuid" => "6d1567c5-08d4-4ecb-8d5d-0ce1ba6b0b99",
              "identifier" => "6d1567c5",
              "name" => "Wow",
              "description" => "t",
              "suspended" => false,
              "limits" => %{
                "memory" => 0,
                "swap" => -1,
                "disk" => 5000,
                "io" => 500,
                "cpu" => 200
              },
              "feature_limits" => %{
                "databases" => 0,
                "allocations" => 0
              },
              "user" => 5,
              "node" => 2,
              "allocation" => 4,
              "nest" => 1,
              "egg" => 15,
              "pack" => nil,
              "container" => %{
                "startup_command" => "./parkertron",
                "image" => "quay.io/parkervcp/pterodactyl-images:parkertron",
                "installed" => true,
                "environment" => %{
                  "STARTUP" => "./parkertron",
                  "P_SERVER_LOCATION" => "test",
                  "P_SERVER_UUID" => "6d1567c5-08d4-4ecb-8d5d-0ce1ba6b0b99"
                }
              },
              "updated_at" => "2018-11-10T19:52:13+00:00",
              "created_at" => "2018-11-10T19:51:23+00:00"
            }
          }
        ],
        meta: %{
          "pagination" => %{
            "total" => 2,
            "count" => 2,
            "per_page" => 50,
            "current_page" => 1,
            "total_pages" => 1,
            "links" => []
          }
        }
      }

    success(conn, body)
  end

  get "/api/application/servers/:id" do
  body = %{
      "object" => "server",
      "attributes" => %{
        "id" => 2,
        "external_id" => nil,
        "uuid" => "47a7052b-f07e-4845-989d-e876e30960f4",
        "identifier" => "47a7052b",
        "name" => "Eat Vegies",
        "description" => "",
        "suspended" => false,
        "limits" => %{
          "memory" => 2048,
          "swap" => -1,
          "disk" => 10000,
          "io" => 500,
          "cpu" => 300
        },
        "feature_limits" => %{
          "databases" => 10,
          "allocations" => 0
        },
        "user" => 1,
        "node" => 2,
        "allocation" => 3,
        "nest" => 1,
        "egg" => 4,
        "pack" => nil,
        "container" => %{
          "startup_command" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
          "image" => "quay.io/pterodactyl/core:java",
          "installed" => true,
          "environment" => %{
            "SERVER_JARFILE" => "server.jar",
            "VANILLA_VERSION" => "latest",
            "STARTUP" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
            "P_SERVER_LOCATION" => "test",
            "P_SERVER_UUID" => "47a7052b-f07e-4845-989d-e876e30960f4"
          }
        },
        "updated_at" => "2018-11-20T14:35:00+00:00",
        "created_at" => "2018-09-29T22:50:16+00:00"
      }
    }
    success(conn, body)
  end

  get "/api/application/servers/external/:external_id" do
    body = %{
      "object" => "server",
      "attributes" => %{
        "id" => 2,
        "external_id" => 10,
        "uuid" => "47a7052b-f07e-4845-989d-e876e30960f4",
        "identifier" => "47a7052b",
        "name" => "Eat Vegies",
        "description" => "",
        "suspended" => false,
        "limits" => %{
          "memory" => 2048,
          "swap" => -1,
          "disk" => 10000,
          "io" => 500,
          "cpu" => 300
        },
        "feature_limits" => %{
          "databases" => 10,
          "allocations" => 0
        },
        "user" => 1,
        "node" => 2,
        "allocation" => 3,
        "nest" => 1,
        "egg" => 4,
        "pack" => nil,
        "container" => %{
          "startup_command" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
          "image" => "quay.io/pterodactyl/core:java",
          "installed" => true,
          "environment" => %{
            "SERVER_JARFILE" => "server.jar",
            "VANILLA_VERSION" => "latest",
            "STARTUP" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
            "P_SERVER_LOCATION" => "test",
            "P_SERVER_UUID" => "47a7052b-f07e-4845-989d-e876e30960f4"
          }
        },
        "updated_at" => "2018-11-20T14:35:00+00:00",
        "created_at" => "2018-09-29T22:50:16+00:00"
      }
    }
    success(conn, body)
  end

  post "/api/application/servers" do
    params = %{
      "external_id" => "test_server",
      "name" => "Test",
      "user" => 1,
      "description" => "Test server",
      "egg" => 15,
      "pack" => 1,
      "docker_image" => "quay.io/pterodactyl/core:java-glibc",
      "startup" => "java -Xms128M -Xmx 1024M -jar server.jar",
      "limits" => %{
        "memory" => 512,
        "swap" => 0,
        "disk" => 1024,
        "io" => 500,
        "cpu" => 100
      },
      "feature_limits" => %{
        "databases" => 1,
        "allocations" => 2
      },
      "environment" => %{
        "DL_VERSION" => "1.12.2"
      },
      "allocation" => %{
        "default" => 28,
        "additional" => [
          3,
          19
        ],
      },
      "deploy" => %{
        "locations" => [1],
        "dedicated_ip" => false,
        "port_range" => []
      },
      "start_on_completion" => true,
      "skip_scripts" => false,
      "oom_disabled" => true
    }

    attributes = %{
        "id" => 53,
        "external_id" => "test_server",
        "uuid" => "d7bcc254-e218-4522-a7fe-9d2d562ad790",
        "identifier" => "d7bcc254",
        "name" => "Test",
        "description" => "Test server",
        "suspended" => false,
        "limits" => %{
          "memory" => 512,
          "swap" => 0,
          "disk" => 1024,
          "io" => 500,
          "cpu" => 100
        },
        "feature_limits" => %{
          "databases" => 1,
          "allocations" => 2
        },
        "user" => 1,
        "node" => 1,
        "allocation" => 28,
        "nest" => 5,
        "egg" => 15,
        "pack" => 1,
        "container" => %{
          "startup_command" => "java -Xms128M -Xmx 1024M -jar server.jar",
          "image" => "quay.io/pterodactyl/core:java-glibc",
          "installed" => false,
          "environment" => %{
            "DL_VERSION" => "1.12.2",
            "STARTUP" => "java -Xms128M -Xmx 1024M -jar server.jar",
            "P_SERVER_LOCATION" => "fr.sys",
            "P_SERVER_UUID" => "d7bcc254-e218-4522-a7fe-9d2d562ad790"
          }
        },
        "updated_at" => "2019-02-23T11:25:35+00:00",
        "created_at" => "2019-02-23T11:25:35+00:00"
    }
    if params != conn.params do
      success(conn, %Server{attributes: attributes})
    else
      #      success(conn, "mandatory params missing in request #{inspect params}")
      failure(conn, 500, "mandatory params missing in request #{inspect conn.params}")
    end
  end

  post "/api/application/servers/:id/details" do
    params = %{
      external_id: "some_id",
      name: "New name",
      user: "1",
      description: "New description"
    }

    attributes = %{
      "id" => 53,
      "external_id" => "some_id",
      "uuid" => "d7bcc254-e218-4522-a7fe-9d2d562ad790",
      "identifier" => "d7bcc254",
      "name" => "New name",
      "description" => "New description",
      "suspended" => false,
      "limits" => %{
        "memory" => 512,
        "swap" => 0,
        "disk" => 1024,
        "io" => 500,
        "cpu" => 100
      },
      "feature_limits" => %{
        "databases" => 1,
        "allocations" => 2
      },
      "user" => 1,
      "node" => 1,
      "allocation" => 28,
      "nest" => 5,
      "egg" => 15,
      "pack" => 1,
      "container" => %{
        "startup_command" => "java -Xms128M -Xmx 1024M -jar server.jar",
        "image" => "quay.io/pterodactyl/core:java-glibc",
        "installed" => false,
        "environment" => %{
          "DL_VERSION" => "1.12.2",
          "STARTUP" => "java -Xms128M -Xmx 1024M -jar server.jar",
          "P_SERVER_LOCATION" => "fr.sys",
          "P_SERVER_UUID" => "d7bcc254-e218-4522-a7fe-9d2d562ad790"
        }
      },
      "updated_at" => "2019-02-23T11:25:35+00:00",
      "created_at" => "2019-02-23T11:25:35+00:00"
    }
    if params != conn.params do
      success(conn, %Server{attributes: attributes})
    else
      failure(conn, 500, "mandatory params missing in request #{inspect conn.params}")
    end
  end

  patch "/api/application/servers/:id" do
    params = conn.params
    if Map.take(params, ["servername", "email", "first_name", "last_name"])
       |> Kernel.map_size() == 4 do
      body = %User{
        object: "server",
        attributes:
          Map.merge(
            %{
              id: id,
              uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
              "2fa": false,
              created_at: "2018-03-18T15:15:17+00:00",
              updated_at: "2018-10-16T21:51:21+00:00"
            },
            params
          )
      }
      success(conn, body)
    else
      #      success(conn, "mandatory params missing in request #{inspect params}")
      failure(conn, 500, "mandatory params missing in request #{inspect params}")
    end
  end

  delete "/api/application/servers/:id" do
    success(conn, "OK")
  end

  defp success(conn, body, code \\ 200) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.resp(code, Poison.encode!(body))
    |> Plug.Conn.send_resp()
  end

  defp failure(conn, status, error_msg \\ "error") do
    conn
    |> Plug.Conn.resp(status, error_msg)
    |> Plug.Conn.send_resp()
  end
end
