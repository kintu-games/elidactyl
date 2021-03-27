defmodule Elidactyl.Schemas.Server.LimitsTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.Limits
  import Limits

  @valid %{
    memory: 512,
    swap: 0,
    disk: 200,
    io: 500,
    cpu: 0,
  }

  def build_changeset(params \\ %{}) do
    changeset(%Limits{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%Limits{}, %{})
      assert_invalid(changeset, :memory, error_message == "can't be blank")
      assert_invalid(changeset, :swap, error_message == "can't be blank")
      assert_invalid(changeset, :disk, error_message == "can't be blank")
      assert_invalid(changeset, :io, error_message == "can't be blank")
      assert_invalid(changeset, :cpu, error_message == "can't be blank")
    end

    test "validates fields types" do
      %{memory: "a"} |> build_changeset() |> assert_invalid(:memory)
      %{swap: "a"} |> build_changeset() |> assert_invalid(:swap)
      %{disk: "a"} |> build_changeset() |> assert_invalid(:disk)
      %{io: "a"} |> build_changeset() |> assert_invalid(:io)
      %{cpu: "a"} |> build_changeset() |> assert_invalid(:cpu)
    end

    test "refutes negative memory values" do
      %{memory: -1} |> build_changeset() |> assert_invalid(:memory)
      %{memory: 0} |> build_changeset() |> assert_valid(:memory)
    end

    test "refutes negative disk values" do
      %{disk: -1} |> build_changeset() |> assert_invalid(:disk)
      %{disk: 0} |> build_changeset() |> assert_valid(:disk)
    end

    test "refutes negative cpu values" do
      %{cpu: -1} |> build_changeset() |> assert_invalid(:cpu)
      %{cpu: 0} |> build_changeset() |> assert_valid(:cpu)
    end

    test "refutes swap values that < -1" do
      %{swap: -2} |> build_changeset() |> assert_invalid(:swap)
      %{swap: -1} |> build_changeset() |> assert_valid(:swap)
      %{swap: 0} |> build_changeset() |> assert_valid(:swap)
    end

    test "refutes io values that < 10 or > 1000" do
      %{io: 9} |> build_changeset() |> assert_invalid(:io)
      %{io: 1001} |> build_changeset() |> assert_invalid(:io)
      %{io: 10} |> build_changeset() |> assert_valid(:io)
      %{io: 20} |> build_changeset() |> assert_valid(:io)
      %{io: 1000} |> build_changeset() |> assert_valid(:io)
    end
  end
end
