defmodule Elidactyl.UserTest do
  use ExUnit.Case
  alias Elidactyl.Schemas.User

  test "valid user changeset with mandatory params" do
    assert %{valid?: true} =
      User.changeset(%User{}, %{
        root_admin: true,
        username: "example",
        email: "example@example.com",
        first_name: "John",
        last_name: "Doe"
      })
  end

  test "valid user changeset with mandatory and optional params" do
    assert %{valid?: true} =
             User.changeset(%User{}, %{
               root_admin: false,
               external_id: "example_ext_id",
               username: "example",
               email: "example@example.com",
               first_name: "John",
               last_name: "Doe",
               language: "en"
             })
  end

  test "invalid changeset with missing email" do
    assert %{valid?: false} =
             User.changeset(%User{}, %{
               username: "example",
               first_name: "John",
               last_name: "Doe"
             })
  end
end
