defmodule Elidactyl.UsersTest do
  use ExUnit.Case
  alias Elidactyl.Application.Users
  alias Elidactyl.Schemas.User

  test "list users" do
    assert {:ok, users} = Users.all()
    assert [
             %User{
               id: 1,
               external_id: nil,
               uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
               username: "codeco",
               email: "codeco@file.properties",
               first_name: "Rihan",
               last_name: "Arfan",
               language: "en",
               root_admin: true,
               "2fa": false,
               created_at: "2018-03-18T15:15:17+00:00",
               updated_at: "2018-10-16T21:51:21+00:00"
             },
             %User{
               id: 4,
               external_id: nil,
               uuid: "f253663c-5a45-43a8-b280-3ea3c752b931",
               username: "wardledeboss",
               email: "wardle315@gmail.com",
               first_name: "Harvey",
               last_name: "Wardle",
               language: "en",
               root_admin: false,
               "2fa": false,
               created_at: "2018-09-29T17:59:45+00:00",
               updated_at: "2018-10-02T18:59:03+00:00"
             }
           ] == users
  end

  test "get user by id" do
    assert {:ok, user} = Users.get_by_id(1)

    %User{
      id: "1",
      external_id: nil,
      uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
      username: "codeco",
      email: "codeco@file.properties",
      first_name: "Rihan",
      last_name: "Arfan",
      language: "en",
      root_admin: true,
      "2fa": false,
      created_at: "2018-03-18T15:15:17+00:00",
      updated_at: "2018-10-16T21:51:21+00:00"
    } = user
  end

  test "get user by external id" do
    assert {:ok, user} = Users.get_by_external_id(10)

    %User{
      id: 1,
      external_id: "10",
      uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
      username: "codeco",
      email: "codeco@file.properties",
      first_name: "Rihan",
      last_name: "Arfan",
      language: "en",
      root_admin: true,
      "2fa": false,
      created_at: "2018-03-18T15:15:17+00:00",
      updated_at: "2018-10-16T21:51:21+00:00"
    } = user
  end

  test "create user" do
    params = %{
      username: "example",
      email: "example@example.com",
      first_name: "John",
      last_name: "Doe",
      language: "en",
      root_admin: true
    }
    assert {:ok, user} = Users.create(params)

    assert struct(%User{
      id: 2,
      uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335",
      "2fa": false,
      created_at: "2018-03-18T15:15:17+00:00",
      updated_at: "2018-10-16T21:51:21+00:00",
      root_admin: true
    }, params) == user
  end

  test "edit user" do
    params = %{
      email: "email@example.com",
      first_name: "John",
      last_name: "Doe",
      language: "en"
    }

    assert {:ok, original_user} = Users.get_by_id(1)
    assert {:ok, edited_user} = Users.update(1, params)

    assert struct(original_user, params) == edited_user
  end

  test "delete user" do
    assert :ok = Users.delete(1)
  end
end
