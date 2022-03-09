defmodule Elidactyl.Schemas.Server.AllocationTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.Allocation
  import Allocation

  @valid %{
    default: 1,
    additional: [2, 3]
  }

  def build_changeset(params \\ %{}) do
    changeset(%Allocation{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%Allocation{}, %{})
      assert_invalid(changeset, :default, error_message == "can't be blank")
      assert_invalid(changeset, :additional, error_message == "can't be blank")
    end

    test "validates fields types" do
      %{default: "a"} |> build_changeset() |> assert_invalid(:default)
      %{additional: 100} |> build_changeset() |> assert_invalid(:additional)
    end

    test "refutes negative default values" do
      %{default: -1} |> build_changeset() |> assert_invalid(:default)
      %{default: 0} |> build_changeset() |> assert_valid(:default)
    end
  end
end
