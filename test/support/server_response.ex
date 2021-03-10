defmodule Elidactyl.ServerResponse do
  @moduledoc """
  Flexible server response builder
  """

  alias Elidactyl.Schemas.Server

  @limits %{memory: 512, swap: 0, disk: 200, io: 500, cpu: 0, threads: nil}
  @limits_keys Map.keys(@limits)

  @feature_limits %{databases: 5, allocations: 5, backups: 2}
  @feature_limits_keys Map.keys(@feature_limits)

  @environment %{
    "P_SERVER_ALLOCATION_LIMIT" => 5,
    "P_SERVER_LOCATION" => "GB",
    "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
    "SERVER_JARFILE" => "server.jar",
    "STARTUP" => "java -Xms128M -Xmx2048M -jar server.jar",
    "VANILLA_VERSION" => "latest"
  }

  @container %{
    image: "quay.io/pterodactyl/core:java",
    installed: true,
    startup_command: "java -Xms128M -Xmx2014M -jar server.jar",
  }
  @container_keys Map.keys(@container)

  @server_keys ~w[
    id external_id uuid identifier name description suspended user node allocation nest egg
    updated_at created_at databases]a

  @spec limits() :: map
  @spec limits(map | nil) :: map
  def limits, do: @limits
  def limits(%{} = overrides), do: limits() |> Map.merge(Map.take(overrides, @limits_keys))
  def limits(_), do: limits()

  @spec feature_limits() :: map
  @spec feature_limits(map | nil) :: map
  def feature_limits, do: @feature_limits
  def feature_limits(%{} = overrides), do: feature_limits() |> Map.merge(Map.take(overrides, @feature_limits_keys))
  def feature_limits(_), do: feature_limits()

  @spec environment() :: map
  @spec environment(map | nil) :: map
  def environment, do: @environment
  def environment(%{} = overrides), do: environment() |> Map.merge(overrides)
  def environment(_), do: environment()

  @spec container() :: map
  @spec container(map | nil) :: map
  def container do
    Map.put(@container, :environment, environment())
  end
  def container(%{} = overrides) do
    container()
    |> Map.merge(Map.take(overrides, @container_keys))
    |> update_in(~w[environment]a, & Map.get(overrides, :environment, &1))
  end
  def container(_), do: container()

  @spec build() :: Server.t
  @spec build(map) :: Server.t
  def build do
    %Server{
      id: 5,
      external_id: "RemoteID1",
      uuid: "1a7ce997-259b-452e-8b4e-cecc464142ca",
      identifier: "1a7ce997",
      name: "Gaming",
      description: "Matt from Wii Sports",
      suspended: false,
      limits: limits(),
      feature_limits: feature_limits(),
      user: 1,
      node: 1,
      allocation: 1,
      nest: 1,
      egg: 5,
      container: container(),
      updated_at: "2020-11-04T21:11:26+00:00",
      created_at: "2019-12-23T06:46:27+00:00",
    }
  end
  def build(%{} = overrides) do
    server =
      build()
      |> Map.from_struct()
      |> Map.merge(Map.take(overrides, @server_keys))
      |> update_in(~w[limits]a, & limits(Map.get(overrides, :limits, &1)))
      |> update_in(~w[feature_limits]a, & feature_limits(Map.get(overrides, :feature_limits, &1)))
      |> update_in(~w[container]a, & container(Map.get(overrides, :container, &1)))
    struct(Server, server)
  end
  def build(overrides) when is_list(overrides) do
    overrides
    |> Enum.into(%{})
    |> build()
  end
end
