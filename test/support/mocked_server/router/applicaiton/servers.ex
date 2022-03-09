defmodule Elidactyl.MockedServer.Router.Application.Servers do
  @moduledoc false

  use Plug.Router

  import Elidactyl.MockedServer.Router.Utils

  alias Elidactyl.MockedServer
  alias Elidactyl.MockedServer.Factory
  alias Elidactyl.MockedServer.ExternalSchema.List, as: ExternalList

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/api/application/servers" do
    %{data: servers} = list = MockedServer.list(:server)

    meta = %{
      pagination: %{
        total: length(servers),
        count: length(servers),
        per_page: 50,
        current_page: 1,
        total_pages: 1,
        links: %{}
      }
    }

    success(conn, %{list | data: add_databases(servers), meta: meta})
  end

  get "/api/application/servers/:id" do
    {id, ""} = Integer.parse(id)
    success(conn, MockedServer.get(:server, id))
  end

  get "/api/application/servers/external/:external_id" do
    %{data: servers} = MockedServer.list(:server)
    server = Enum.find(servers, &match?(%{attributes: %{external_id: ^external_id}}, &1))
    success(conn, server)
  end

  post "/api/application/servers" do
    container = %{
      "environment" => Map.get(conn.params, "environment", %{}),
      "image" => Map.get(conn.params, "docker_image"),
      "startup_command" => Map.get(conn.params, "startup"),
      "installed" => false
    }

    params =
      conn.params
      |> Map.drop(~w[environment docker_image startup allocation])
      |> Map.put("container", container)

    success(conn, MockedServer.put(:server, params), 201)
  end

  patch "/api/application/servers/:id/details" do
    {id, ""} = Integer.parse(id)
    %{attributes: prev} = MockedServer.get(:server, id)
    %{attributes: next} = Factory.build(:server, conn.params)
    MockedServer.delete(:server, id)
    success(conn, MockedServer.put(:server, prev |> Map.merge(next) |> Map.merge(%{id: id})))
  end

  delete "/api/application/servers/:id" do
    success(conn, "", 204)
  end

  delete "/api/application/servers/:id/force" do
    success(conn, "", 204)
  end

  patch "/api/application/servers/:id/build" do
    {id, ""} = Integer.parse(id)
    limits = Map.take(conn.params, ~w[memory swap disk io cpu threads])

    params =
      conn.params
      |> Map.drop(~w[memory swap disk io cpu threads])
      |> Map.put("limits", limits)

    %{attributes: prev} = MockedServer.get(:server, id)
    %{attributes: next} = Factory.build(:server, params)
    MockedServer.delete(:server, id)
    success(conn, MockedServer.put(:server, prev |> Map.merge(next) |> Map.merge(%{id: id})))
  end

  patch "/api/application/servers/:id/startup" do
    {id, ""} = Integer.parse(id)

    container = %{
      "environment" => Map.get(conn.params, "environment", %{}),
      "image" => Map.get(conn.params, "image"),
      "startup_command" => Map.get(conn.params, "startup")
    }

    params =
      conn.params
      |> Map.drop(~w[environment image startup])
      |> Map.put("container", container)

    %{attributes: prev} = MockedServer.get(:server, id)
    %{attributes: next} = Factory.build(:server, params)
    MockedServer.delete(:server, id)
    success(conn, MockedServer.put(:server, prev |> Map.merge(next) |> Map.merge(%{id: id})))
  end

  post "/api/application/servers/:id/suspend" do
    success(conn, "", 204)
  end

  post "/api/application/servers/:id/unsuspend" do
    success(conn, "", 204)
  end

  post "/api/application/servers/:id/reinstall" do
    success(conn, "", 204)
  end

  defp add_databases(servers) do
    %{data: databases} = MockedServer.list(:database)

    Enum.map(servers, fn %{attributes: %{id: id}} = server ->
      server_databases = Enum.filter(databases, &match?(%{attributes: %{server: ^id}}, &1))
      MockedServer.add_relationship(server, :databases, %ExternalList{data: server_databases})
    end)
  end
end
