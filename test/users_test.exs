defmodule Elidactyl.UsersTest do
  use ExUnit.Case
  alias Elidactyl.Users

  test "list users" do
    assert {:ok, []} = Users.list_users()
  end
end
