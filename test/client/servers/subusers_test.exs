defmodule Elidactyl.Client.Server.SubusersTest do
  use ExUnit.Case, async: false
  use Elidactyl.RequestCase

  alias Elidactyl.MockedServer
  alias Elidactyl.Schemas.Server.SubuserV1
  alias Elidactyl.Client

  setup do
    %{attributes: user1} = MockedServer.put(:server_subuser, server: 1)
    %{attributes: user2} = MockedServer.put(:server_subuser, server: 1)
    %{user1: user1, user2: user2}
  end

  describe "list_all_server_subusers/1" do
    test "lists allocations for a node", %{user1: %{email: email1}, user2: %{email: email2}} do
      assert {:ok, subusers} = Client.list_all_server_subusers(1)
      assert length(subusers) == 2
      assert Enum.find(subusers, & &1.email == email1)
      assert Enum.find(subusers, & &1.email == email2)
    end
  end

  describe "create_server_subuser/2" do
    test "creates subuser" do
      params = %{
        username: "subuser3bvo",
        email: "subuser3@example.com",
        image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
        "2fa_enabled": false,
        permissions: ~w[control.console control.start websocket.connect],
      }

      assert {:ok, subuser} = Client.create_server_subuser(1, params)
      assert subuser.username == "subuser3bvo"
      assert {:ok, _} = Ecto.UUID.cast(subuser.uuid)
      assert subuser.email == "subuser3@example.com"
      assert subuser.image == "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65"
      assert subuser."2fa_enabled" == false
      assert subuser.permissions == ~w[control.console control.start websocket.connect]
    end
  end

  describe "get_server_subuser/2" do
    test "gets subuser details", %{user1: user} do
      assert {:ok, %SubuserV1{} = subuser} = Client.get_server_subuser(1, user.uuid)
      assert subuser."2fa_enabled" == user."2fa_enabled"
      assert subuser.email == user.email
      assert subuser.image == user.image
      assert subuser.permissions == user.permissions
      assert subuser.username == user.username
    end
  end

  describe "update_server_subuser/3" do
    test "updates subuser", %{user1: user} do
      params = %{
        username: "subuser3bvo",
        email: "subuser3@example.com",
        image: "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65",
        "2fa_enabled": not user."2fa_enabled",
        permissions: ~w[control.console],
      }

      assert {:ok, %SubuserV1{} = subuser} = Client.update_server_subuser(1, user.uuid, params)
      assert subuser."2fa_enabled" != user."2fa_enabled"
      assert subuser.email == "subuser3@example.com"
      assert subuser.image == "https:\/\/gravatar.com\/avatar\/8b28d32aaa64a1564450d16f71a81f65"
      assert subuser.permissions == ~w[control.console]
      assert subuser.username == "subuser3bvo"
    end
  end

  describe "delete_server_subuser/2" do
    test "deletes subuser", %{user1: user} do
      assert {:ok, ""} = Client.delete_server_subuser(1, user.uuid)
    end
  end
end
