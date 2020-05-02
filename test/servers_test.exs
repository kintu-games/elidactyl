defmodule Elidactyl.ServerTest do
  use ExUnit.Case

  alias Elidactyl.Servers
  alias Elidactyl.Server

  test "list users" do
    assert {:ok, users} = Servers.list_servers()
    assert [
             %Server{
               pack: nil,
               server_owner: nil,
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
               feature_limits: %{
                 allocations: 0,
                 databases: 10
               },
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
               updated_at: "2018-11-20T14:35:00+00:00",
               user: 1,
               uuid: "47a7052b-f07e-4845-989d-e876e30960f4"
             },
             %Server{
               pack: nil,
               server_owner: nil,
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
               feature_limits: %{
                 allocations: 0,
                 databases: 0
               },
               id: 6,
               identifier: "6d1567c5",
               limits: %{
                 cpu: 200,
                 disk: 5000,
                 io: 500,
                 memory: 0,
                 swap: -1
               },
               name: "Wow",
               nest: 1,
               node: 2,
               updated_at: "2018-11-10T19:52:13+00:00",
               user: 5,
               uuid: "6d1567c5-08d4-4ecb-8d5d-0ce1ba6b0b99"
             }
           ] == users
  end
  #
  #  test "get user by id" do
  #    assert {:ok, user} = Users.get_user_by_id(1)
  #
  #    %User{
  #      id: "1",
  #      external_id: nil,
  #      uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
  #      username: "codeco",
  #      email: "codeco@file.properties",
  #      first_name: "Rihan",
  #      last_name: "Arfan",
  #      language: "en",
  #      root_admin: true,
  #      "2fa": false,
  #      created_at: "2018-03-18T15:15:17+00:00",
  #      updated_at: "2018-10-16T21:51:21+00:00"
  #    } = user
  #  end
  #
  #  test "get user by external id" do
  #    assert {:ok, user} = Users.get_user_by_external_id(10)
  #
  #    %User{
  #      id: 1,
  #      external_id: "10",
  #      uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
  #      username: "codeco",
  #      email: "codeco@file.properties",
  #      first_name: "Rihan",
  #      last_name: "Arfan",
  #      language: "en",
  #      root_admin: true,
  #      "2fa": false,
  #      created_at: "2018-03-18T15:15:17+00:00",
  #      updated_at: "2018-10-16T21:51:21+00:00"
  #    } = user
  #  end
  #
  #  test "create user" do
  #    params = %{
  #      external_id: "example_ext_id",
  #      username: "example",
  #      email: "example@example.com",
  #      first_name: "John",
  #      last_name: "Doe",
  #      language: "en",
  #      is_admin: true
  #    }
  #    assert {:ok, user} = Users.create_user(params)
  #
  #    assert struct(%User{
  #             id: 2,
  #             uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
  #             "2fa": false,
  #             created_at: "2018-03-18T15:15:17+00:00",
  #             updated_at: "2018-10-16T21:51:21+00:00"
  #           }, params) == user
  #  end
  #
  #  test "edit user" do
  #    params = %{
  #      email: "email@example.com",
  #      first_name: "John",
  #      last_name: "Doe",
  #      language: "en"
  #    }
  #
  #    assert {:ok, original_user} = Users.get_user_by_id(1)
  #    assert {:ok, edited_user} = Users.edit_user(1, params)
  #
  #    assert struct(original_user, params) == edited_user
  #  end
  #
  #  test "delete user" do
  #    assert :ok = Users.delete_user(1)
  #  end
end
