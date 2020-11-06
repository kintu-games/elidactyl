defmodule Elidactyl.MockedServer.Router.Application.Servers.SubUsers do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  alias Elidactyl.MockedServer.ExternalSchema.List
  alias Elidactyl.MockedServer.ExternalSchema.ServerSubuser

  get "/api/application/servers/:id/users" do
    if id == "1" do
      allocations =
        [
          %ServerSubuser{
            attributes: %{
              uuid: "73f233ca-99e0-47a9-bd46-efd3296d7ad9",
              username: "subuser1uxk",
              email: "subuser1@example.com",
              image: "https://gravatar.com/avatar/0da5391b64449c1ecbfd4349184377c",
              #                                                           :"2fa_enabled": false
              created_at: "2020-06-12T23:18:43+01:00"
            }
          },
          %ServerSubuser{
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