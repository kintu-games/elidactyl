defmodule Elidactyl.Schemas.UserTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.User
  import User

  @valid %{
    external_id: "external-id",
    username: "testuser",
    email: "user@test.com",
    first_name: "John",
    last_name: "Smith",
    password: "12345",
    root_admin: false,
    language: "en"
  }

  def build_changeset(params \\ %{}) do
    changeset(%User{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%User{}, %{})
      assert_invalid(changeset, :username, error_message == "can't be blank")
      assert_invalid(changeset, :email, error_message == "can't be blank")
      assert_invalid(changeset, :first_name, error_message == "can't be blank")
      assert_invalid(changeset, :last_name, error_message == "can't be blank")
      assert_invalid(changeset, :root_admin, error_message == "can't be blank")
      assert_invalid(changeset, :language, error_message == "can't be blank")
    end

    test "allows optional fields to not present" do
      %User{}
      |> changeset(Map.drop(@valid, ~w[password external_id]a))
      |> assert_valid()
    end

    test "validates fields types" do
      %{external_id: 100} |> build_changeset() |> assert_invalid(:external_id)
      %{username: 100} |> build_changeset() |> assert_invalid(:username)
      %{email: 100} |> build_changeset() |> assert_invalid(:email)
      %{first_name: 100} |> build_changeset() |> assert_invalid(:first_name)
      %{last_name: 100} |> build_changeset() |> assert_invalid(:last_name)
      %{password: 100} |> build_changeset() |> assert_invalid(:password)
      %{root_admin: "a"} |> build_changeset() |> assert_invalid(:root_admin)
      %{language: 100} |> build_changeset() |> assert_invalid(:language)
    end

    test "refutes invalid email values" do
      %{email: "test"} |> build_changeset() |> assert_invalid(:email)
      %{email: "test.com"} |> build_changeset() |> assert_invalid(:email)
      %{email: "test@"} |> build_changeset() |> assert_invalid(:email)
      %{email: "@test.com"} |> build_changeset() |> assert_invalid(:email)
    end

    test "refutes email values longer than 255 chars" do
      %{email: String.pad_leading("", 249, "x") <> "@test.com"}
      |> build_changeset()
      |> assert_invalid(:email)
    end

    test "refutes external_id values longer than 255 chars" do
      %{external_id: String.pad_leading("", 256, "x")}
      |> build_changeset()
      |> assert_invalid(:external_id)
    end

    test "refutes username values longer than 255 chars" do
      %{username: String.pad_leading("", 256, "x")}
      |> build_changeset()
      |> assert_invalid(:username)
    end

    test "refutes first_name values longer than 255 chars" do
      %{first_name: String.pad_leading("", 256, "x")}
      |> build_changeset()
      |> assert_invalid(:first_name)
    end

    test "refutes last_name values longer than 255 chars" do
      %{last_name: String.pad_leading("", 256, "x")}
      |> build_changeset()
      |> assert_invalid(:last_name)
    end
  end
end
