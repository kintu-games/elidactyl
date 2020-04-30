defmodule Elidactyl.MockServer do
  use Plug.Router
  alias Elidactyl.MockServer.List
  alias Elidactyl.MockServer.User

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

  get "/api/application/users/:user_id" do
    body = %User{
      object: "user",
      attributes: %{
        id: user_id,
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
    if Map.take(params, ["username", "email", "first_name", "last_name"]) |> Kernel.map_size() == 4 do
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
      success(conn, body)
    else
#      success(conn, "mandatory params missing in request #{inspect params}")
      failure(conn, 500, "mandatory params missing in request #{inspect params}")
    end
  end

  patch "/api/application/users/:user_id" do
    params = conn.params
    if Map.take(params, ["username", "email", "first_name", "last_name"]) |> Kernel.map_size() == 4 do
      body = %User{
        object: "user",
        attributes:
          Map.merge(
            %{
              id: user_id,
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

  defp success(conn, body) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.resp(200, Poison.encode!(body))
    |> Plug.Conn.send_resp()
  end

  defp failure(conn, status, error_msg \\ "error") do
    conn
    |> Plug.Conn.resp(status, error_msg)
    |> Plug.Conn.send_resp()
  end
end
