defmodule Elidactyl.UsersTest do
  use ExUnit.Case
  alias Elidactyl.Users
  alias Elidactyl.User

  test "list users" do
    assert {:ok, users} = Users.list_users()
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
    assert {:ok, user} = Users.get_user_by_external_id(10)

    %User{
      id: 1,
      external_id: 10,
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

  test "get user by external_id" do

  end
end
