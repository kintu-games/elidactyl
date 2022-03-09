defmodule Elidactyl.MockedServer.Router.Client.Servers do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

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
end
