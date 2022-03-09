defmodule Elidactyl.MockedServer.Router.Client.Servers.Subusers do
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

  get "/api/client/servers/:id/users" do
    {id, ""} = Integer.parse(id)
    %{data: users} = MockedServer.list(:server_subuser)

    users =
      users
      |> Enum.filter(&match?(%{attributes: %{server: ^id}}, &1))
      |> Enum.map(&serialize/1)

    success(conn, %ExternalList{data: users})
  end

  post "/api/client/servers/:id/users" do
    success(conn, MockedServer.put(:server_subuser, conn.params), 201)
  end

  get "/api/client/servers/:id/users/:uuid" do
    {id, ""} = Integer.parse(id)
    %{data: users} = MockedServer.list(:server_subuser)
    user = Enum.find(users, &match?(%{attributes: %{server: ^id, uuid: ^uuid}}, &1))
    success(conn, serialize(user))
  end

  post "/api/client/servers/:id/users/:uuid" do
    {id, ""} = Integer.parse(id)
    %{data: users} = MockedServer.list(:server_subuser)

    %{attributes: prev} =
      Enum.find(users, &match?(%{attributes: %{server: ^id, uuid: ^uuid}}, &1))

    %{attributes: next} = Factory.build(:server_subuser, conn.params)
    next = Map.take(next, conn.params |> Map.keys() |> Enum.map(&String.to_existing_atom/1))
    MockedServer.delete(:server_subuser, prev.id)
    next = MockedServer.put(:server_subuser, prev |> Map.merge(next) |> Map.merge(%{id: id}))
    success(conn, serialize(next))
  end

  delete "/api/client/servers/:id/users/:uuid" do
    success(conn, "", 204)
  end

  defp serialize(user), do: %{user | attributes: Map.drop(user.attributes, ~w[id server]a)}
end
