defmodule Elidactyl.Application.UsersTest do
  use ExUnit.Case, async: false
  use Elidactyl.RequestCase

  alias Elidactyl.MockedServer
  alias Elidactyl.Application.Users
  alias Elidactyl.Schemas.User

  setup do
    %{attributes: user1} = MockedServer.put(:user)
    %{attributes: user2} = MockedServer.put(:user)
    %{user1: user1, user2: user2}
  end

  describe "all/0" do
    test "lists users", %{user1: %{id: id1}, user2: %{id: id2}} do
      assert {:ok, users} = Users.all()
      assert length(users) == 2
      assert Enum.any?(users, & &1.id == id1)
      assert Enum.any?(users, & &1.id == id2)
    end
  end

  describe "get_by_id/1" do
    test "gets user by id", %{user1: %{id: id}} do
      assert {:ok, %User{} = user} = Users.get_by_id(id)

      assert user.id == id
      assert is_binary(user.uuid)
      assert is_binary(user.username)
      assert is_binary(user.email)
      assert is_binary(user.first_name)
      assert is_binary(user.last_name)
      assert user.language == "en"
      assert is_boolean(user.root_admin)
      assert is_boolean(user."2fa")
    end
  end

  describe "get_by_external_id/1" do
    test "gets user by external id", %{user1: %{external_id: id}} do
      assert {:ok, %User{}} = Users.get_by_external_id(id)
    end
  end

  describe "create/1" do
    test "creates user" do
      params = %{
        username: "example",
        email: "example@example.com",
        first_name: "John",
        last_name: "Doe",
        language: "en",
        root_admin: true
      }
      assert {:ok, user} = Users.create(params)
      assert is_integer(user.id)
      assert {:ok, _} = Ecto.UUID.cast(user.uuid)
      assert user.root_admin == true
      assert user.username == "example"
      assert user.email == "example@example.com"
      assert user.first_name == "John"
      assert user.last_name == "Doe"
      assert user.language == "en"
    end
  end

  describe "update/2" do
    test "edits user", %{user1: %{id: id}} do
      params = %{
        email: "email@example.com",
        first_name: "John",
        last_name: "Doe",
        language: "ru",
      }

      assert {:ok, user} = Users.update(id, params)
      assert user.email == "email@example.com"
      assert user.first_name == "John"
      assert user.last_name == "Doe"
      assert user.language == "ru"
    end
  end

  describe "delete/1" do
    test "deletes user" do
      assert :ok = Users.delete(1)
    end
  end
end
