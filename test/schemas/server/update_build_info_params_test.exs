defmodule Elidactyl.Schemas.Server.UpdateBuildInfoParamsTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.UpdateBuildInfoParams
  import UpdateBuildInfoParams

  @valid %{
    allocation: 1,
    memory: 512,
    swap: 0,
    disk: 200,
    io: 500,
    cpu: 0,
    threads: nil,
    feature_limits: %{databases: 5, allocations: 5, backups: 2}
  }

  def build_changeset(params \\ %{}) do
    changeset(%UpdateBuildInfoParams{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%UpdateBuildInfoParams{}, %{})
      assert_invalid(changeset, :allocation, error_message == "can't be blank")
      assert_invalid(changeset, :memory, error_message == "can't be blank")
      assert_invalid(changeset, :swap, error_message == "can't be blank")
      assert_invalid(changeset, :io, error_message == "can't be blank")
      assert_invalid(changeset, :cpu, error_message == "can't be blank")
      assert_invalid(changeset, :disk, error_message == "can't be blank")
      assert_invalid(changeset, :feature_limits, error_message == "can't be blank")
    end

    test "allows optional fields to not present" do
      %UpdateBuildInfoParams{}
      |> changeset(Map.drop(@valid, ~w[threads]a))
      |> assert_valid()
    end

    test "validates fields types" do
      %{allocation: "a"} |> build_changeset() |> assert_invalid(:allocation)
      %{memory: "a"} |> build_changeset() |> assert_invalid(:memory)
      %{swap: "a"} |> build_changeset() |> assert_invalid(:swap)
      %{disk: "a"} |> build_changeset() |> assert_invalid(:disk)
      %{io: "a"} |> build_changeset() |> assert_invalid(:io)
      %{cpu: "a"} |> build_changeset() |> assert_invalid(:cpu)
      %{threads: true} |> build_changeset() |> assert_invalid(:threads)
      %{feature_limits: "a"} |> build_changeset() |> assert_invalid(:feature_limits)
    end

    test "allows nil, integer, string, list and range threads" do
      %{threads: nil} |> build_changeset() |> assert_valid(:threads)
      %{threads: 1} |> build_changeset() |> assert_valid(:threads)
      %{threads: ""} |> build_changeset() |> assert_valid(:threads)
      %{threads: "1"} |> build_changeset() |> assert_valid(:threads)
      %{threads: "1,2,3"} |> build_changeset() |> assert_valid(:threads)
      %{threads: "1-3,5"} |> build_changeset() |> assert_valid(:threads)
    end

    test "refutes invalid threads values" do
      %{threads: "5-3"} |> build_changeset() |> assert_invalid(:threads)
      %{threads: "1, 2"} |> build_changeset() |> assert_invalid(:threads)
      %{threads: false} |> build_changeset() |> assert_invalid(:threads)
      %{threads: ["1", "2"]} |> build_changeset() |> assert_invalid(:threads)
      %{threads: [1, 2]} |> build_changeset() |> assert_invalid(:threads)
    end

    test "refutes zero and negative allocation values" do
      %{allocation: 0} |> build_changeset() |> assert_invalid(:allocation)
      %{allocation: -1} |> build_changeset() |> assert_invalid(:allocation)
      %{allocation: 1} |> build_changeset() |> assert_valid(:allocation)
    end

    test "refutes negative memory values" do
      %{memory: -1} |> build_changeset() |> assert_invalid(:memory)
      %{memory: 0} |> build_changeset() |> assert_valid(:memory)
    end

    test "refutes swap values that < -1" do
      %{swap: -2} |> build_changeset() |> assert_invalid(:swap)
      %{swap: -1} |> build_changeset() |> assert_valid(:swap)
      %{swap: 0} |> build_changeset() |> assert_valid(:swap)
    end

    test "refutes negative io values" do
      %{io: -1} |> build_changeset() |> assert_invalid(:io)
      %{io: 0} |> build_changeset() |> assert_valid(:io)
    end

    test "accepts cpu values only from 0 to 100" do
      %{cpu: -1} |> build_changeset() |> assert_invalid(:cpu)
      %{cpu: 0} |> build_changeset() |> assert_valid(:cpu)
      %{cpu: 50} |> build_changeset() |> assert_valid(:cpu)
      %{cpu: 100} |> build_changeset() |> assert_valid(:cpu)
      %{cpu: 101} |> build_changeset() |> assert_invalid(:cpu)
    end

    test "refutes negative disk values" do
      %{disk: -1} |> build_changeset() |> assert_invalid(:disk)
      %{disk: 0} |> build_changeset() |> assert_valid(:disk)
    end
  end
end
