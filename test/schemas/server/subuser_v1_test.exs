defmodule Elidactyl.Schemas.Server.SubuserV1Test do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.SubuserV1
  import SubuserV1

  @valid %{
    uuid: "1a7ce997-259b-452e-8b4e-cecc464142ca",
    username: "john",
    email: "john@test.com",
    image: "avatar.jpg",
    "2fa_enabled": true,
    permissions: ["admin"],
  }

  def build_changeset(params \\ %{}) do
    changeset(%SubuserV1{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%SubuserV1{}, %{})
      assert_invalid(changeset, :email, error_message == "can't be blank")
      assert_invalid(changeset, :permissions, error_message == "can't be blank")
    end

    test "allows optional fields to not present" do
      %SubuserV1{}
      |> changeset(Map.drop(@valid, ~w[uuid username image 2fa_enabled]a))
      |> assert_valid()
    end

    test "validates fields types" do
      %{uuid: 100} |> build_changeset() |> assert_invalid(:uuid)
      %{username: 100} |> build_changeset() |> assert_invalid(:username)
      %{email: 100} |> build_changeset() |> assert_invalid(:email)
      %{image: 100} |> build_changeset() |> assert_invalid(:image)
      %{"2fa_enabled": "a"} |> build_changeset() |> assert_invalid(:"2fa_enabled")
      %{permissions: "a"} |> build_changeset() |> assert_invalid(:permissions)
    end
  end
end
