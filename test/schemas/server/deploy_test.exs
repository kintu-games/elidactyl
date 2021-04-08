defmodule Elidactyl.Schemas.Server.DeployTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.Deploy
  import Deploy

  @valid %{
    locations: [1, 2],
    dedicated_ip: true,
    port_range: ["1001", "1002"],
  }

  def build_changeset(params \\ %{}) do
    changeset(%Deploy{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%Deploy{}, %{})
      assert_invalid(changeset, :dedicated_ip, error_message == "can't be blank")
    end

    test "allows optional fields to not present" do
      %Deploy{}
      |> changeset(Map.drop(@valid, ~w[locations port_range]a))
      |> assert_valid()
    end

    test "validates fields types" do
      %{locations: "a"} |> build_changeset() |> assert_invalid(:locations)
      %{dedicated_ip: 100} |> build_changeset() |> assert_invalid(:dedicated_ip)
      %{port_range: "a"} |> build_changeset() |> assert_invalid(:port_range)
    end
  end
end
