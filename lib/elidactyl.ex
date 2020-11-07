defmodule Elidactyl do
  @moduledoc """
  API for Pterodactyl panel
  """

  alias Elidactyl.Users
  alias Elidactyl.Servers

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
      {:ok,
             [
               %Elidactyl.Schemas.Server{
                 allocation: 3,
                 container: %{
                   environment: %{
                     "P_SERVER_LOCATION" => "test",
                     "P_SERVER_UUID" => "47a7052b-f07e-4845-989d-e876e30960f4",
                     "SERVER_JARFILE" => "server.jar",
                     "STARTUP" => "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}",
                     "VANILLA_VERSION" => "latest"
                   },
                   image: "quay.io/pterodactyl/core:java",
                   installed: true,
                   startup_command: "java -Xms128M -Xmx%{%{SERVER_MEMORY}}M -jar %{%{SERVER_JARFILE}}"
                 },
                 created_at: "2018-09-29T22:50:16+00:00",
                 description: "",
                 egg: 4,
                 external_id: nil,
                 feature_limits: %{allocations: 0, databases: 10},
                 id: 2,
                 identifier: "47a7052b",
                 limits: %{
                   cpu: 300,
                   disk: 10000,
                   io: 500,
                   memory: 2048,
                   swap: -1
                 },
                 name: "Eat Vegies",
                 nest: 1,
                 node: 2,
                 pack: nil,
                 server_owner: nil,
                 suspended: false,
                 updated_at: "2018-11-20T14:35:00+00:00",
                 user: 1,
                 uuid: "47a7052b-f07e-4845-989d-e876e30960f4"
               },
               %Elidactyl.Schemas.Server{
                 allocation: 4,
                 container: %{
                   environment: %{
                     "P_SERVER_LOCATION" => "test",
                     "P_SERVER_UUID" => "6d1567c5-08d4-4ecb-8d5d-0ce1ba6b0b99",
                     "STARTUP" => "./parkertron"
                   },
                   image: "quay.io/parkervcp/pterodactyl-images:parkertron",
                   installed: true,
                   startup_command: "./parkertron"
                 },
                 created_at: "2018-11-10T19:51:23+00:00",
                 description: "t",
                 egg: 15,
                 external_id: nil,
                 feature_limits: %{allocations: 0, databases: 0},
                 id: 6,
                 identifier: "6d1567c5",
                 limits: %{cpu: 200, disk: 5000, io: 500, memory: 0, swap: -1},
                 name: "Wow",
                 nest: 1,
                 node: 2,
                 pack: nil,
                 server_owner: nil,
                 suspended: false,
                 updated_at: "2018-11-10T19:52:13+00:00",
                 user: 5,
                 uuid: "6d1567c5-08d4-4ecb-8d5d-0ce1ba6b0b99"
               }
             ]}
  """
  def get_all_servers() do
    Servers.list_servers()
  end

  @doc ~S"""
  Creating a new server with given params

  ## Examples
      iex> params = %{
      ...>  user: 1,
      ...>  allocation: %{
      ...>    default: 28,
      ...>    additional: [3, 19]
      ...>  },
      ...>  startup: "java -Xms128M -Xmx 1024M -jar server.jar",
      ...>  docker_image: "quay.io/pterodactyl/core:java-glibc",
      ...>  environment: %{
      ...>    "DL_VERSION" => "1.12.2"
      ...>  },
      ...>  description: "Test server",
      ...>  egg: 15,
      ...>  external_id: "test_server",
      ...>  feature_limits: %{
      ...>    databases: 1,
      ...>    allocations: 2
      ...>  },
      ...>  limits: %{
      ...>    memory: 512,
      ...>    swap: 0,
      ...>    disk: 1024,
      ...>    io: 500,
      ...>    cpu: 100
      ...>  },
      ...>  name: "Test",
      ...>  pack: 1,
      ...>  deploy: %{
      ...>    locations: [1],
      ...>    dedicated_ip: false,
      ...>    port_range: []
      ...>  },
      ...>  start_on_completion: true,
      ...>  skip_scripts: false,
      ...>  oom_disabled: true
      ...> }
      iex> Elidactyl.create_server(params)
      {:ok, %Elidactyl.Schemas.Server{allocation: 28, container: %{environment: %{"DL_VERSION" => "1.12.2","P_SERVER_LOCATION" => "fr.sys","P_SERVER_UUID" => "d7bcc254-e218-4522-a7fe-9d2d562ad790","STARTUP" => "java -Xms128M -Xmx 1024M -jar server.jar"}, image: "quay.io/pterodactyl/core:java-glibc", installed: false, startup_command: "java -Xms128M -Xmx 1024M -jar server.jar"}, created_at: "2019-02-23T11:25:35+00:00", description: "Test server", egg: 15, external_id: "test_server", feature_limits: %{allocations: 2, databases: 1}, id: 53, identifier: "d7bcc254", limits: %{cpu: 100, disk: 1024, io: 500, memory: 512, swap: 0}, name: "Test", nest: 5, node: 1, pack: 1, server_owner: nil, suspended: false, updated_at: "2019-02-23T11:25:35+00:00", user: 1, uuid: "d7bcc254-e218-4522-a7fe-9d2d562ad790"}}
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
