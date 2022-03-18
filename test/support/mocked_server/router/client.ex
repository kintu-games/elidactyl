defmodule Elidactyl.MockedServer.Router.Client do
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

    success(conn, Jason.encode!(servers))
  end

  get "/api/client/servers/:server_id/resources" do
    resp = %{
      "object" => "stats",
      "attributes" => %{
        "current_state" => "starting",
        "is_suspended" => false,
        "resources" => %{
          "memory_bytes" => 588_701_696,
          "cpu_absolute" => 0,
          "disk_bytes" => 130_156_361,
          "network_rx_bytes" => 694_220,
          "network_tx_bytes" => 337_090
        }
      }
    }

    success(conn, resp)
  end
end
