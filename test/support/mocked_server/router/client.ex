defmodule Elidactyl.MockedServer.Router.Client do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Poison
  )

  plug(:match)
  plug(:dispatch)

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
end