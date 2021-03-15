defmodule Elidactyl do
  @moduledoc """
  API for Pterodactyl panel
  """

  alias Elidactyl.Application.Users
  alias Elidactyl.Application.Servers

  @doc ~S"""
  Get all users.

  ## Examples
      iex> Elidactyl.get_all_users()
      {:ok, [%Elidactyl.Schemas.User{external_id: nil, password: nil, "2fa": false, created_at: "2018-03-18T15:15:17+00:00", email: "codeco@file.properties", first_name: "Rihan", id: 1, language: "en", last_name: "Arfan", root_admin: true, updated_at: "2018-10-16T21:51:21+00:00", username: "codeco", uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335"}, %Elidactyl.Schemas.User{"2fa": false, created_at: "2018-09-29T17:59:45+00:00", email: "wardle315@gmail.com", external_id: nil, first_name: "Harvey", id: 4, language: "en", last_name: "Wardle", password: nil, root_admin: false, updated_at: "2018-10-02T18:59:03+00:00", username: "wardledeboss", uuid: "f253663c-5a45-43a8-b280-3ea3c752b931"}]}
  """
  def get_all_users() do
    Users.all()
  end

  @doc ~S"""
  Create user with given params.

  ## Examples
      iex> params = %{
      ...>  username: "example",
      ...>  email: "example@example.com",
      ...>  first_name: "John",
      ...>  last_name: "Doe",
      ...>  language: "en",
      ...>  root_admin: false
      ...> }
      iex> Elidactyl.create_user(params)
      {:ok, %Elidactyl.Schemas.User{external_id: nil, password: nil, "2fa": false, created_at: "2018-03-18T15:15:17+00:00", email: "example@example.com", first_name: "John", id: 2, language: "en", last_name: "Doe", root_admin: false, updated_at: "2018-10-16T21:51:21+00:00", username: "example", uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335"}}
  """
  def create_user(params) do
    Users.create(params)
  end

  @doc ~S"""
  Update user using pterodactyl internal user id and params.

  ## Examples
      iex> params = %{
      ...>  email: "email@example.com",
      ...>  first_name: "John",
      ...>  last_name: "Doe",
      ...>  language: "en"
      ...> }
      iex> Elidactyl.update_user(1, params)
      {:ok, %Elidactyl.Schemas.User{external_id: nil, password: nil, "2fa": false, created_at: "2018-03-18T15:15:17+00:00", email: "email@example.com", first_name: "John", id: "1", language: "en", last_name: "Doe", root_admin: true, updated_at: "2018-10-16T21:51:21+00:00", username: "codeco", uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335"}}
  """
  def update_user(id, params) do
    Users.update(id, params)
  end

  @doc ~S"""
  Delete user using internal pterodactyl user id.

  ## Examples
      iex> Elidactyl.delete_user(1)
      :ok
  """
  def delete_user(id) do
    Users.delete(id)
  end


  @doc ~S"""
  Get all servers.

  ## Examples
      iex> Elidactyl.get_all_servers()
      {
        :ok,
        [
          %Elidactyl.Schemas.Server{
            allocation: 1,
            container: %{
              environment: %{
                "P_SERVER_LOCATION" => "Test",
                "P_SERVER_UUID" => "1a7ce997-259b-452e-8b4e-cecc464142ca",
                "SERVER_JARFILE" => "server.jar",
                "STARTUP" => "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
                "VANILLA_VERSION" => "latest"
              },
              image: "quay.io/pterodactyl/core:java",
              installed: true,
              startup_command: "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}"
            },
            created_at: "2019-12-23T06:46:27+00:00",
            databases: [
              %Elidactyl.Schemas.Server.Database{created_at: "2020-06-12T23:00:13+01:00", database: "s5_perms", host: 4, id: 1, max_connections: 0, remote: "%", server: 5, updated_at: "2020-06-12T23:00:13+01:00", username: "u5_QsIAp1jhvS"},
              %Elidactyl.Schemas.Server.Database{created_at: "2020-06-12T23:00:20+01:00", database: "s5_coreprotect", host: 4, id: 2, max_connections: 0, remote: "%", server: 5, updated_at: "2020-06-12T23:00:20+01:00", username: "u5_2jtJx1nO1d"}
            ],
            description: "Matt from Wii Sports",
            egg: 5,
            external_id: "RemoteId1",
            feature_limits: %{allocations: 5, databases: 5, backups: 2},
            id: 5,
            identifier: "1a7ce997",
            limits: %{cpu: 0, disk: 200, io: 500, memory: 512, swap: 0, threads: nil},
            name: "Wuhu Island",
            nest: 1,
            node: 1,
            pack: nil,
            server_owner: nil,
            suspended: false,
            updated_at: "2020-06-13T04:20:53+00:00",
            user: 1,
            uuid: "1a7ce997-259b-452e-8b4e-cecc464142ca"
          }
        ]
      }
  """
  def get_all_servers() do
    Servers.list_servers()
  end

  @doc ~S"""
  Create a new server with given params

  ## Examples
      iex> params = %{
      ...> user: 1,
      ...> egg: 15,
      ...>  docker_image: "quay.io/pterodactyl/core:java-glibc",
      ...> startup: "java -Xms128M -Xmx 1024M -jar server.jar",
      ...> environment: %{
      ...>   "DL_VERSION" => "1.12.2"
      ...> },
      ...> limits: %{
      ...>   memory: 512,
      ...>   swap: 0,
      ...>   disk: 1024,
      ...>   io: 500,
      ...>   cpu: 100
      ...> },
      ...> feature_limits: %{
      ...>   databases: 1,
      ...>   backups: 1
      ...> },
      ...> allocation: %{
      ...>   default: 28,
      ...>   additional: [3, 19]
      ...> }
      ...>}
      iex> Elidactyl.create_server(params)
      {
        :ok,
        %Elidactyl.Schemas.Server{
          allocation: 17,
          container: %{
            environment: %{
              "P_SERVER_LOCATION" => "GB",
              "P_SERVER_UUID" => "d557c19c-8b21-4456-a9e5-181beda429f4",
              "STARTUP" => "java -Xms128M -Xmx128M -jar server.jar",
              "BUNGEE_VERSION" => "latest",
              "P_SERVER_ALLOCATION_LIMIT" => 0,
              "SERVER_JARFILE" => "server.jar"
            },
            image: "quay.io/pterodactyl/core =>java",
            installed: false,
            startup_command: "java -Xms128M -Xmx128M -jar server.jar"
          },
          created_at: "2020-10-29T01:38:59+00:00",
          databases: [],
          description: "",
          egg: 1,
          external_id: nil,
          feature_limits: %{allocations: 0, databases: 5, backups: 1},
          id: 7,
          identifier: "d557c19c",
          limits: %{cpu: 100, disk: 512, io: 500, memory: 128, swap: 0, threads: nil},
          name: "Building",
          nest: 1,
          node: 1,
          pack: nil,
          server_owner: nil,
          suspended: false,
          updated_at: "2020-10-29T01:38:59+00:00",
          user: 1,
          uuid: "d557c19c-8b21-4456-a9e5-181beda429f4"
        }
      }
  """
  def create_server(params) do
    Servers.create_server(params)
  end

  @doc ~S"""
  Delete a server using internal pterodactyl server id.

  ## Examples
      iex> Elidactyl.delete_server(1)
      :ok
  """
  def delete_server(id) do
    Servers.delete_server(id)
  end
end
