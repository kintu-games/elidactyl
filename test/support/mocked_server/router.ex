defmodule Elidactyl.MockedServer.Router do
  @moduledoc false

  use Plug.Router

  alias Elidactyl.MockedServer.Router.Client
  alias Elidactyl.MockedServer.Router.Application

  import Elidactyl.MockedServer.Router.Utils

  plug(Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

  # pterodactyl 1.0
  match("/api/client/servers/:id/users/*_", to: Client.Servers.Subusers)

  # pterodactyl 0.7
  match("/api/client/:id/servers", to: Client.Servers)
  match("/api/client/*_", to: Client)

  # match "/api/application/servers/:id/users", to: Application.Servers.SubUsers
  match("/api/application/users/*_", to: Application.Users)
  match("/api/application/servers/*_", to: Application.Servers)
  match("/api/application/nodes/*_", to: Application.Nodes)
  match("/api/application/nests/*_", to: Application.Nests)

  get("/test", do: success(conn, %{"type" => "get"}))
  post("/test", do: success(conn, %{"type" => "post", "params" => conn.params}))
  put("/test", do: success(conn, %{"type" => "put", "params" => conn.params}))
  patch("/test", do: success(conn, %{"type" => "patch", "params" => conn.params}))
  delete("/test", do: success(conn, %{"type" => "delete"}))

  get("/test_not_found", do: failure(conn, 404))
end
