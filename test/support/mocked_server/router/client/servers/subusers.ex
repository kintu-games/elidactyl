defmodule Elidactyl.MockedServer.Router.Client.Servers.Subusers do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  alias Elidactyl.MockedServer.ExternalSchema.List
  alias Elidactyl.MockedServer.ExternalSchema.ServerSubuser

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Poison
  )

  plug(:match)
  plug(:dispatch)

  get "/api/client/servers/:id/users" do
    subusers =
      [
        %ServerSubuser{
          attributes: %{
            uuid: "60a7aec3-e17d-4aa9-abb3-56d944d204b4",
            username: "subuser2jvc",
            email: "subuser2@example.com",
            image: "https:\/\/gravatar.com\/avatar\/3bb1c751a8b3488f4a4c70eddfe898d8",
            "2fa_enabled": false,
            created_at: "2020-06-12T23:31:41+01:00",
            permissions: [
              "control.console",
              "control.start",
              "websocket.connect"
            ]
          }
        },
        %ServerSubuser{
          attributes: %{
            uuid: "1287632d-9224-40c0-906e-f543423400bc",
            username: "subuser3bvo",
            email: "subuser3@example.com",
            image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
            "2fa_enabled": false,
            created_at: "2020-07-13T14:27:46+01:00",
            permissions: [
              "control.console",
              "control.start",
              "websocket.connect"
            ]
          }
        }
      ]
    success(conn, %List{data: subusers})
  end

  post "/api/client/servers/:id/users" do
    params = %{
      "username" => "subuser3bvo",
      "email" => "subuser3@example.com",
      "image" => "https =>\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
      "2fa_enabled" => false,
      "permissions" => [
        "control.console",
        "control.start",
        "websocket.connect"
      ]
    }

    attributes = %{
        uuid: "1287632d-9224-40c0-906e-f543423400bc",
        username: "subuser3bvo",
        email: "subuser3@example.com",
        image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
        "2fa_enabled": false,
        created_at: "2020-07-13T14:27:46+01:00",
        permissions: [
          "control.console",
          "control.start",
          "websocket.connect"
        ]
    }

    if params != conn.params do
      success(conn, %ServerSubuser{attributes: attributes})
    else
      failure(conn, 500, "some params missing in request #{inspect conn.params}")
    end
  end

  get "/api/client/servers/:id/users/1287632d-9224-40c0-906e-f543423400bc" do
    attributes = %{
      uuid: "1287632d-9224-40c0-906e-f543423400bc",
      username: "subuser3bvo",
      email: "subuser3@example.com",
      image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
      "2fa_enabled": false,
      created_at: "2020-07-13T14:27:46+01:00",
      permissions: [
        "control.console",
        "control.start",
        "websocket.connect"
      ]
    }

    success(conn, %ServerSubuser{attributes: attributes})
  end

  post "/api/client/servers/:id/users/1287632d-9224-40c0-906e-f543423400bc" do
    params = %{
      "username" => "subuser3bvo",
      "email" => "subuser3@example.com",
      "image" => "https =>\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
      "2fa_enabled" => false,
      "permissions" => [
        "control.console",
        "control.start",
        "websocket.connect"
      ]
    }

    attributes = %{
      uuid: "1287632d-9224-40c0-906e-f543423400bc",
      username: "subuser3bvo",
      email: "subuser3@example.com",
      image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
      "2fa_enabled": false,
      created_at: "2020-07-13T14:27:46+01:00",
      permissions: [
        "control.console",
        "control.start",
        "websocket.connect"
      ]
    }

    if params != conn.params do
      success(conn, %ServerSubuser{attributes: attributes})
    else
      failure(conn, 500, "some params missing in request #{inspect conn.params}")
    end
  end

  delete "/api/client/servers/:id/users/1287632d-9224-40c0-906e-f543423400bc" do
    success(conn, "", 204)
  end
end