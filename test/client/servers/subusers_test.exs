defmodule Elidactyl.Client.Server.SubusersTest do
  use ExUnit.Case

  alias Elidactyl.Schemas.Server.SubuserV1
  alias Elidactyl.Client


  test "list allocations for a node" do
    assert {:ok, subusers} = Client.list_all_server_subusers(1)
    assert [
             %SubuserV1{
               id: nil,
               updated_at: nil,
               "2fa_enabled": false,
               created_at: "2020-06-12T23:31:41+01:00",
               email: "subuser2@example.com",
               image: "https://gravatar.com/avatar/3bb1c751a8b3488f4a4c70eddfe898d8",
               permissions: ["control.console", "control.start", "websocket.connect"],
               username: "subuser2jvc",
               uuid: "60a7aec3-e17d-4aa9-abb3-56d944d204b4"
             },
             %SubuserV1{
               id: nil,
               updated_at: nil,
               "2fa_enabled": false,
               created_at: "2020-07-13T14:27:46+01:00",
               email: "subuser3@example.com",
               image: "https://gravatar.com/avatar/8b28d32aaa64a1564450d16f71a81f65",
               permissions: ["control.console", "control.start", "websocket.connect"],
               username: "subuser3bvo",
               uuid: "1287632d-9224-40c0-906e-f543423400bc"
             }
           ] == subusers
  end

  test "create subuser" do
    params = %{
      username: "subuser3bvo",
      email: "subuser3@example.com",
      image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
      "2fa_enabled": false,
      permissions: [
        "control.console",
        "control.start",
        "websocket.connect"
      ]
    }

    assert {:ok, subuser} = Client.create_server_subuser(1, params)
    assert subuser == %SubuserV1{
      uuid: "1287632d-9224-40c0-906e-f543423400bc",
      username: "subuser3bvo",
      email: "subuser3@example.com",
      image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
      "2fa_enabled": false,
      created_at: "2020-07-13T14:27:46+01:00",
      permissions: [
        "control.console",
        "control.start",
        "websocket.connect"
      ]
    }
  end

  test "get subuser details" do
    assert {:ok, subuser} = Client.get_server_subuser(1, "1287632d-9224-40c0-906e-f543423400bc")
    assert subuser == %SubuserV1{
             uuid: "1287632d-9224-40c0-906e-f543423400bc",
             username: "subuser3bvo",
             email: "subuser3@example.com",
             image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
             "2fa_enabled": false,
             created_at: "2020-07-13T14:27:46+01:00",
             permissions: [
               "control.console",
               "control.start",
               "websocket.connect"
             ]
           }
  end

  test "update subuser" do
    params = %{
      username: "subuser3bvo",
      email: "subuser3@example.com",
      image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
      "2fa_enabled": false,
      permissions: [
        "control.console",
        "control.start",
        "websocket.connect"
      ]
    }

    assert {:ok, subuser} = Client.update_server_subuser(1, "1287632d-9224-40c0-906e-f543423400bc", params)
    assert subuser == %SubuserV1{
             uuid: "1287632d-9224-40c0-906e-f543423400bc",
             username: "subuser3bvo",
             email: "subuser3@example.com",
             image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
             "2fa_enabled": false,
             created_at: "2020-07-13T14:27:46+01:00",
             permissions: [
               "control.console",
               "control.start",
               "websocket.connect"
             ]
           }
  end

  test "delete subuser" do
    assert {:ok, ""} = Client.delete_server_subuser(1, "1287632d-9224-40c0-906e-f543423400bc")
  end
end