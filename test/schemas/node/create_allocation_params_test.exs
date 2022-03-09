defmodule Elidactyl.Schemas.Node.CreateAllocationParamsTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Node.CreateAllocationParams
  import CreateAllocationParams

  @valid %{
    ip: "10.0.0.1",
    ports: ~w[25565],
    alias: "test_alias"
  }

  def build_changeset(params \\ %{}) do
    changeset(%CreateAllocationParams{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%CreateAllocationParams{}, %{})
      assert_invalid(changeset, :ip, error_message == "can't be blank")
      assert_invalid(changeset, :ports, error_message == "can't be blank")
    end

    test "allows optional fields to not present" do
      %CreateAllocationParams{}
      |> changeset(Map.drop(@valid, ~w[alias]a))
      |> assert_valid()
    end

    test "validates fields types" do
      %{ip: 100} |> build_changeset() |> assert_invalid(:ip)
      %{ports: "a"} |> build_changeset() |> assert_invalid(:ports)
      %{alias: 100} |> build_changeset() |> assert_invalid(:alias)
    end
  end
end
