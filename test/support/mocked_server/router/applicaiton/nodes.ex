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
end
