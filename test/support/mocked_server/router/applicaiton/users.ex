defmodule Elidactyl.MockedServer.Router.Application.Users do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  alias Elidactyl.MockedServer
  alias Elidactyl.MockedServer.Factory

  plug(
    Plug.Parsers,
    parsers: [:json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  get "/api/application/users" do
    success(conn, MockedServer.list(:user))
  end

  get "/api/application/users/:id" do
    {id, ""} = Integer.parse(id)
    success(conn, MockedServer.get(:user, id))
  end

  get "/api/application/users/external/:external_id" do
    %{data: users} = MockedServer.list(:user)
    user = Enum.find(users, &match?(%{attributes: %{external_id: ^external_id}}, &1))
    success(conn, user)
  end

  post "/api/application/users" do
    params = conn.params
    if map_size(Map.take(params, ["username", "email", "first_name", "last_name"])) == 4 do
      success(conn, MockedServer.put(:user, params), 201)
    else
      failure(conn, 500, "mandatory params missing in request #{inspect params}")
    end
  end

  patch "/api/application/users/:id" do
    params = conn.params
    if map_size(Map.take(params, ["username", "email", "first_name", "last_name"])) == 4 do
      {id, ""} = Integer.parse(id)
      %{attributes: prev} = MockedServer.get(:user, id)
      %{attributes: next} = Factory.build(:user, params)
      next = Map.take(next, params |> Map.keys() |> Enum.map(&String.to_existing_atom/1))
      MockedServer.delete(:user, id)
      success(conn, MockedServer.put(:user, prev |> Map.merge(next) |> Map.merge(%{id: id})))
    else
      failure(conn, 500, "mandatory params missing in request #{inspect params}")
    end
  end

  delete "/api/application/users/:id" do
    success(conn, "", 204)
  end
end
