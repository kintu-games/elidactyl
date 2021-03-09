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


end
