defmodule Elidactyl.Schemas.Server.UpdateDetailsParamsTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.UpdateDetailsParams
  import UpdateDetailsParams

  @valid %{
    external_id: "external-id",
    name: "Server Name",
    description: "Server Description",
    user: 1,
  }

  def build_changeset(params \\ %{}) do
    changeset(%UpdateDetailsParams{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%UpdateDetailsParams{}, %{})
      assert_invalid(changeset, :name, error_message == "can't be blank")
      assert_invalid(changeset, :user, error_message == "can't be blank")
    end

    test "allows optional fields to not present" do
      %UpdateDetailsParams{}
      |> changeset(Map.drop(@valid, ~w[external_id description]a))
      |> assert_valid()
    end

    test "validates field types" do
      %{external_id: 100} |> build_changeset() |> assert_invalid(:external_id)
      %{name: 100} |> build_changeset() |> assert_invalid(:name)
      %{description: 100} |> build_changeset() |> assert_invalid(:description)
      %{user: "a"} |> build_changeset() |> assert_invalid(:user)
    end

    test "refutes external_id values longer than 191 chars" do
      %{external_id: String.pad_leading("", 192, "x")} |> build_changeset() |> assert_invalid(:external_id)
    end

    test "refutes name values longer than 255 chars" do
      %{name: String.pad_leading("", 256, "x")} |> build_changeset() |> assert_invalid(:name)
    end
  end
end
