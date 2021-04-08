defmodule Elidactyl.Schemas.Server.Subuser.PermissionTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.Subuser.Permission
  import Permission

  @valid %{
    subuser_id: 1,
    permission: "permission",
  }

  def build_changeset(params \\ %{}) do
    changeset(%Permission{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%Permission{}, %{})
      assert_invalid(changeset, :subuser_id, error_message == "can't be blank")
      assert_invalid(changeset, :permission, error_message == "can't be blank")
    end

    test "validates fields types" do
      %{subuser_id: "a"} |> build_changeset() |> assert_invalid(:subuser_id)
      %{permission: 100} |> build_changeset() |> assert_invalid(:permission)
    end
  end
end
