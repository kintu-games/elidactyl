defmodule Elidactyl.Schemas.Server.UpdateStartupParamsTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.UpdateStartupParams
  import UpdateStartupParams

  @valid %{
    startup: "java -Xms128M -Xmx{{SERVER_MEMORY}}M -jar {{SERVER_JARFILE}}",
    environment: %{
      "SERVER_JARFILE" => "server.jar",
      "VANILLA_VERSION" => "latest"
    },
    egg: 5,
    image: "quay.io/pterodactyl/core:java",
    skip_scripts: false
  }

  def build_changeset(params \\ %{}) do
    changeset(%UpdateStartupParams{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%UpdateStartupParams{}, %{})
      assert_invalid(changeset, :startup, error_message == "can't be blank")
      assert_invalid(changeset, :egg, error_message == "can't be blank")
      assert_invalid(changeset, :image, error_message == "can't be blank")
    end

    test "allows optional fields to not present" do
      %UpdateStartupParams{}
      |> changeset(Map.drop(@valid, ~w[environment skip_scripts]a))
      |> assert_valid()
    end

    test "validates field types" do
      %{startup: 0} |> build_changeset() |> assert_invalid(:startup)
      %{environment: "a"} |> build_changeset() |> assert_invalid(:environment)
      %{egg: "a"} |> build_changeset() |> assert_invalid(:egg)
      %{image: 0} |> build_changeset() |> assert_invalid(:image)
      %{skip_scripts: "a"} |> build_changeset() |> assert_invalid(:skip_scripts)
    end

    test "refutes zero and negative egg values" do
      %{egg: 0} |> build_changeset() |> assert_invalid(:egg)
      %{egg: -1} |> build_changeset() |> assert_invalid(:egg)
      %{egg: 1} |> build_changeset() |> assert_valid(:egg)
    end

    test "refutes startup values longer than 255 chars" do
      %{startup: String.pad_leading("", 256, "x")}
      |> build_changeset()
      |> assert_invalid(:startup)
    end

    test "refutes image values longer than 255 chars" do
      %{image: String.pad_leading("", 256, "x")} |> build_changeset() |> assert_invalid(:image)
    end
  end
end
