defmodule Elidactyl.MockedServer.Router.Application.Users do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  alias Elidactyl.MockedServer.ExternalSchema.List
  alias Elidactyl.MockedServer.ExternalSchema.User

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/api/application/users" do
    body = %List{
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

  get "/api/application/users/:id" do
    body = %User{
      object: "user",
      attributes: %{
        id: id,
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
    if Map.take(params, ["username", "email", "first_name", "last_name"])
       |> Kernel.map_size() == 4 do
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
      success(conn, body, 201)
    else
      #      success(conn, "mandatory params missing in request #{inspect params}")
      failure(conn, 500, "mandatory params missing in request #{inspect params}")
    end
  end

  patch "/api/application/users/:id" do
    params = conn.params
    if Map.take(params, ["username", "email", "first_name", "last_name"])
       |> Kernel.map_size() == 4 do
      body = %User{
        object: "user",
        attributes:
          Map.merge(
            %{
              id: id,
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

  delete "/api/application/users/:id" do
    success(conn, "", 204)
  end

end
