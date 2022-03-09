defmodule Elidactyl.Schemas.Server.FeatureLimitsTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.FeatureLimits
  import FeatureLimits

  @valid %{
    databases: 2,
    backups: 5,
    allocations: 3
  }

  def build_changeset(params \\ %{}) do
    changeset(%FeatureLimits{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%FeatureLimits{}, %{})
      assert_invalid(changeset, :databases, error_message == "can't be blank")
      assert_invalid(changeset, :backups, error_message == "can't be blank")
      assert_invalid(changeset, :allocations, error_message == "can't be blank")
    end

    test "validates fields types" do
      %{databases: "a"} |> build_changeset() |> assert_invalid(:databases)
      %{backups: "a"} |> build_changeset() |> assert_invalid(:backups)
      %{allocations: "a"} |> build_changeset() |> assert_invalid(:allocations)
    end

    test "refutes negative databases values" do
      %{databases: -1} |> build_changeset() |> assert_invalid(:databases)
      %{databases: 0} |> build_changeset() |> assert_valid(:databases)
    end

    test "refutes negative backups values" do
      %{backups: -1} |> build_changeset() |> assert_invalid(:backups)
      %{backups: 0} |> build_changeset() |> assert_valid(:backups)
    end

    test "refutes negative allocations values" do
      %{allocations: -1} |> build_changeset() |> assert_invalid(:allocations)
      %{allocations: 0} |> build_changeset() |> assert_valid(:allocations)
    end
  end
end
