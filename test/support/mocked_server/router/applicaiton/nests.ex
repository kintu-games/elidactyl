defmodule Elidactyl.MockedServer.Router.Application.Nests do
  @moduledoc false

  use Plug.Router
  import Elidactyl.MockedServer.Router.Utils

  alias Elidactyl.MockedServer
  alias Elidactyl.MockedServer.ExternalSchema.List, as: ExternalList
  alias Elidactyl.MockedServer.ExternalSchema.NullResource
  alias Elidactyl.MockedServer.ExternalSchema.Nest
  alias Elidactyl.MockedServer.ExternalSchema.Nest.Egg

  plug(Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Jason)
  plug(:match)
  plug(:dispatch)

  get "/api/application/nests/:nest_id/eggs" do
    {nest_id, ""} = Integer.parse(nest_id)
    %{query_params: params} = conn = Plug.Conn.fetch_query_params(conn)
    include = parse_include(params["include"])
    list = MockedServer.list(:egg)

    eggs =
      list.data
      |> Enum.filter(&match?(%{attributes: %{nest: ^nest_id}}, &1))
      |> add_references(include)

    success(conn, %{list | data: eggs})
  end

  get "/api/application/nests/:nest_id/eggs/:egg_id" do
    {nest_id, ""} = Integer.parse(nest_id)
    {egg_id, ""} = Integer.parse(egg_id)
    %{query_params: params} = conn = Plug.Conn.fetch_query_params(conn)
    include = parse_include(params["include"])

    with {:ok, _} <- find_nest(nest_id),
         {:ok, %Egg{attributes: %{nest: ^nest_id}} = egg} <- find_egg(egg_id) do
      [egg] = add_references([egg], include)
      success(conn, egg)
    else
      {:error, status, error} -> failure(conn, status, error)
      {:ok, %Egg{}} -> failure(conn, 404, "not found egg #{egg_id} in nest #{nest_id}")
    end
  end

  defp find_nest(nest_id) do
    case MockedServer.get(:nest, nest_id) do
      %Nest{} = nest -> {:ok, nest}
      _ -> {:error, 404, "not found nest #{nest_id}"}
    end
  end

  defp find_egg(egg_id) do
    case MockedServer.get(:egg, egg_id) do
      %Egg{} = egg -> {:ok, egg}
      _ -> {:error, 404, "not found egg #{egg_id}"}
    end
  end

  defp add_references(eggs, include) do
    eggs
    |> add_nest(include)
    |> add_servers(include)
    |> add_config(include)
    |> add_script(include)
    |> add_variables(include)
  end

  defp add_nest(eggs, %{"nest" => true}) do
    Enum.map(
      eggs,
      &MockedServer.add_relationship(&1, :nest, MockedServer.get(:nest, &1.attributes[:nest]))
    )
  end

  defp add_nest(eggs, _), do: eggs

  defp add_servers(eggs, %{"servers" => true}) do
    %{data: servers} = MockedServer.list(:server)

    Enum.map(eggs, fn %{attributes: %{id: id}} = egg ->
      egg_servers = Enum.filter(servers, &match?(%{attributes: %{egg: ^id}}, &1))
      MockedServer.add_relationship(egg, :servers, %ExternalList{data: egg_servers})
    end)
  end

  defp add_servers(eggs, _), do: eggs

  defp add_config(eggs, %{"config" => true}) do
    Enum.map(eggs, &MockedServer.add_relationship(&1, :config, %NullResource{}))
  end

  defp add_config(eggs, _), do: eggs

  defp add_script(eggs, %{"script" => true}) do
    Enum.map(eggs, &MockedServer.add_relationship(&1, :script, %NullResource{}))
  end

  defp add_script(eggs, _), do: eggs

  defp add_variables(eggs, %{"variables" => true}) do
    %{data: vars} = MockedServer.list(:egg_variable)

    Enum.map(eggs, fn %{attributes: %{id: id}} = egg ->
      egg_vars = Enum.filter(vars, &match?(%{attributes: %{egg_id: ^id}}, &1))
      MockedServer.add_relationship(egg, :variables, %ExternalList{data: egg_vars})
    end)
  end

  defp add_variables(eggs, _), do: eggs

  defp parse_include(include) when is_binary(include) and byte_size(include) > 0 do
    include |> String.split(",") |> Enum.into(%{}, &{&1, true})
  end

  defp parse_include(_), do: %{}
end
