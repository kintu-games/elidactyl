defmodule Elidactyl.Factory do
  @moduledoc false

  @maps ~w[server database egg egg_variable nest egg_config limits feature_limits container environment script]a

  @spec build(atom, any) :: any
  def build(subj, opts \\ %{})
  def build(:id, _), do: System.unique_integer(~w[positive monotonic]a)
  def build(:uuid, _), do: Ecto.UUID.generate()
  def build(:boolean, _), do: Enum.random([true, false])
  def build(:email, _), do: "support@pterodactyl.io"
  def build(:docker_image, _), do: "quay.io/pterodactyl/core:java"
  def build(:startup_command, _), do: "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}"
  def build(:base64, size) do
    size
    |> :crypto.strong_rand_bytes()
    |> Base.encode64()
    |> String.slice(0..(size - 1))
  end
  def build(map, attributes) when map in @maps do
    Map.merge(defaults(map), Enum.into(attributes, %{}), &deep_merge/3)
  end

  @spec defaults(atom) :: map
  def defaults(:limits), do: %{memory: 512, swap: 0, disk: 200, io: 500, cpu: 0, threads: nil}
  def defaults(:feature_limits), do: %{databases: 5, allocations: 5, backups: 2}
  def defaults(:container) do
    %{
      startup_command: build(:startup_command),
      image: build(:docker_image),
      installed: build(:boolean),
      environment: build(:environment)
    }
  end
  def defaults(:environment) do
    %{
      "SERVER_JARFILE" => "server.jar",
      "VANILLA_VERSION" => "latest",
      "STARTUP" => build(:startup_command),
      "P_SERVER_LOCATION" => "Test",
      "P_SERVER_UUID" => build(:uuid),
    }
  end
  @egg_config_stops ~w[stop end]
  def defaults(:egg_config) do
    %{
      files: egg_config_files(),
      startup: egg_config_startup(),
      stop: Enum.random(@egg_config_stops),
      logs: Enum.random([[], %{custom: build(:boolean), location: "proxy.log.0"}]),
      extends: nil,
    }
  end
  @script_shells ~w[bash ash]
  @script_containers ~w[alpine:3.9 openjdk:8]
  def defaults(:script) do
    %{
      privileged: build(:boolean),
      install: "#!/bin/bash\r\n# Forge Installation Script\r\n#\r\n#",
      entry: Enum.random(@script_shells),
      container: Enum.random(@script_containers),
      extends: nil,
    }
  end

  @server_names ["Wuhu Island", "Gaming", "Building"]
  def defaults(:server) do
    <<identifier::binary-8, _::binary>> = uuid = build(:uuid)
    %{
      id: build(:id),
      external_id: "RemoteId#{build(:id)}",
      uuid: uuid,
      indentifier: identifier,
      name: Enum.random(@server_names),
      description: "",
      suspended: build(:boolean),
      limits: build(:limits),
      feature_limits: build(:feature_limits),
      user: build(:id),
      node: build(:id),
      allocation: build(:id),
      nest: build(:id),
      egg: build(:id),
      pack: nil,
      container: build(:container),
    }
    |> add_timestamps()
  end
  def defaults(:database) do
    server_id = build(:id)
    %{
      id: build(:id),
      server: server_id,
      host: build(:id),
      database: "s#{server_id}_perms",
      username: "u#{server_id}_#{build(:base64, 10)}",
      remote: "%",
      max_connections: 0,
    }
    |> add_timestamps()
  end
  @nest_names ["Minecraft"]
  def defaults(:nest) do
    %{
      id: build(:id),
      uuid: build(:uuid),
      author: build(:email),
      name: Enum.random(@nest_names),
      description: "",
    }
    |> add_timestamps()
  end
  @egg_names ["Bungeecord", "Forge Minecraft", "Paper"]
  def defaults(:egg) do
    %{
      id: build(:id),
      uuid: build(:uuid),
      name: Enum.random(@egg_names),
      nest: build(:id),
      author: build(:email),
      description: "",
      docker_image: build(:docker_image),
      config: build(:egg_config),
      startup: build(:startup_command),
      script: build(:script),
    }
    |> add_timestamps()
  end
  @egg_variable_names [
    "Bungeecord Version", "Bungeecord Jar File", "Server Jar File", "Forge version", "Build Type",
    "Minecraft Version", "Download Path", "Build Number", "Sponge Version", "Server Version",
  ]
  @egg_variable_rules ~w[required|string|max:20 required|numeric|digits_between:1,3 required|string|between:3,15]
  def defaults(:egg_variable) do
    name = Enum.random(@egg_variable_names)
    env_variable = name |> String.replace(~r/\s+/, "_") |> String.upcase()
    %{
      id: build(:id),
      egg_id: build(:id),
      name: name,
      description: "",
      env_variable: env_variable,
      default_value: "",
      user_viewable: build(:boolean),
      user_editable: build(:boolean),
      rules: Enum.random(@egg_variable_rules),
    }
    |> add_timestamps()
  end

  defp deep_merge(:environment, _, v2), do: v2
  defp deep_merge(:files, _, v2), do: v2
  defp deep_merge(:startup, _, v2), do: v2
  defp deep_merge(:logs, _, v2), do: v2
  defp deep_merge(_k, %{} = v1, %{} = v2), do: Map.merge(v1, v2, &deep_merge/3)
  defp deep_merge(_k, _v1, v2), do: v2

  defp add_timestamps(map) do
    now = NaiveDateTime.utc_now()
    about_week_ago = NaiveDateTime.add(now, -1 * Enum.random(5..13) * 24 * 3600)
    about_month_ago = NaiveDateTime.add(now, -1 * Enum.random(20..40) * 24 * 3600)
    map
    |> Map.put_new(:created_at, about_month_ago)
    |> Map.put_new(:updated_at, about_week_ago)
  end

  defp egg_config_files do
    [
      %{
        "config.yml" => %{
          parser: "yaml",
          find: %{
            "listeners[0].query_enabled" => true,
            "listeners[0].query_port" => "{{server.build.default.port}}",
            "listeners[0].host" => "0.0.0.0:{{server.build.default.port}}",
            "servers.*.address" => %{
              "127.0.0.1" => "{{config.docker.interface}}",
              "localhost" => "{{config.docker.interface}}",
            },
          },
        },
      },
      %{
        "server.properties" => %{
          parser: "properties",
          find: %{
            "server-ip" => "0.0.0.0",
            "enable-query" => "true",
            "server-port" => "{{server.build.default.port}}",
            "query.port" => "{{server.build.default.port}}",
          },
        },
      },
    ] |> Enum.random()
  end

  defp egg_config_startup do
    [
      %{
        "done" => "Listening on ",
        "userInteraction" => ["Listening on /0.0.0.0:25577"],
      },
      %{
        "done" => ")! For help, type ",
        "userInteraction" => ["Go to eula.txt for more info."],
      }
    ] |> Enum.random()
  end
end
