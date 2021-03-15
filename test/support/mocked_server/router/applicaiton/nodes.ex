defmodule Elidactyl.MockedServer.Router.Application.Nodes do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  alias Elidactyl.MockedServer.ExternalSchema.List
  alias Elidactyl.MockedServer.ExternalSchema.Node.Allocation

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/api/application/nodes/:id/allocations" do
    if id == "1" do
      allocations =
        [
          %Allocation{
            attributes: %{
              alias: "steam",
              assigned: false,
              id: 1,
              ip: "1.2.3.4",
              port: 1000
            }
          },
          %Allocation{
            attributes: %{
              alias: "rcon",
              assigned: false,
              id: 2,
              ip: "1.2.3.4",
              port: 2000
            }
          }
        ]
      success(conn, %List{data: allocations})
    else
      failure(conn, 404, "not found node #{inspect id}")
    end
  end

  get "/api/application/nodes/:id/configuration" do
    if id == "1" do
      configuration = %{
        "debug" => false,
        "uuid" => "1046d1d1-b8ef-4771-82b1-2b5946d33397",
        "token_id" => "iAcosCn1KCAgVjVO",
        "token" => "FanPzLCptUxkGow3vi7Z",
        "api" => %{
          "host" => "0.0.0.0",
          "port" => 8080,
          "ssl" => %{
            "enabled" => true,
            "cert" => "/etc/letsencrypt/live/pterodactyl.file.properties/fullchain.pem",
            "key" => "/etc/letsencrypt/live/pterodactyl.file.properties/privkey.pem",
          },
          "upload_limit" => 100,
        },
        "system" => %{
          "data" => "/srv/daemon-data",
          "sftp" => %{"bind_port" => 2022}
        },
        "remote" => "https://pterodactyl.file.properties",
      }
      success(conn, configuration)
    else
      failure(conn, 404, "not found node #{inspect id}")
    end
  end

  get "/api/application/nodes/:id" do
    if id == "1" do
      node = %{
        "object" => "node",
        "attributes" => %{
          "id" => 1,
          "uuid" => "1046d1d1-b8ef-4771-82b1-2b5946d33397",
          "public" => true,
          "name" => "Test",
          "description" => "Test",
          "location_id" => 1,
          "fqdn" => "pterodactyl.file.properties",
          "scheme" => "https",
          "behind_proxy" => false,
          "maintenance_mode" => false,
          "memory" => 2048,
          "memory_overallocate" => 0,
          "disk" => 5000,
          "disk_overallocate" => 0,
          "upload_size" => 100,
          "daemon_listen" => 8080,
          "daemon_sftp" => 2022,
          "daemon_base" => "/srv/daemon-data",
          "created_at" => "2019-12-22T04:44:51+00:00",
          "updated_at" => "2019-12-22T04:44:51+00:00",
        }
      }
      success(conn, node)
    else
      failure(conn, 404, "not found node #{inspect id}")
    end
  end

  get "/api/application/nodes" do
    list = %{
      "object" => "list",
      "data" => [
        %{
          "object" => "node",
          "attributes" => %{
            "id" => 1,
            "uuid" => "1046d1d1-b8ef-4771-82b1-2b5946d33397",
            "public" => true,
            "name" => "Test",
            "description" => "Test",
            "location_id" => 1,
            "fqdn" => "pterodactyl.file.properties",
            "scheme" => "https",
            "behind_proxy" => false,
            "maintenance_mode" => false,
            "memory" => 2048,
            "memory_overallocate" => 0,
            "disk" => 5000,
            "disk_overallocate" => 0,
            "upload_size" => 100,
            "daemon_listen" => 8080,
            "daemon_sftp" => 2022,
            "daemon_base" => "/srv/daemon-data",
            "created_at" => "2019-12-22T04:44:51+00:00",
            "updated_at" => "2019-12-22T04:44:51+00:00"
          }
        },
        %{
          "object" => "node",
          "attributes" => %{
            "id" => 3,
            "uuid" => "71b15cf6-909a-4b60-aa04-abb4c8f98f61",
            "public" => true,
            "name" => "2",
            "description" => "e",
            "location_id" => 1,
            "fqdn" => "pterodactyl.file.properties",
            "scheme" => "https",
            "behind_proxy" => false,
            "maintenance_mode" => false,
            "memory" => 100,
            "memory_overallocate" => 0,
            "disk" => 100,
            "disk_overallocate" => 0,
            "upload_size" => 100,
            "daemon_listen" => 8080,
            "daemon_sftp" => 2022,
            "daemon_base" => "/var/lib/pterodactyl/volumes",
            "created_at" => "2020-06-23T04:50:37+00:00",
            "updated_at" => "2020-06-23T04:50:37+00:00"
          }
        }
      ],
      "meta" => %{
        "pagination" => %{
          "total" => 2,
          "count" => 2,
          "per_page" => 50,
          "current_page" => 1,
          "total_pages" => 1,
          "links" => %{}
        }
      }
    }
    success(conn, list)
  end
end
