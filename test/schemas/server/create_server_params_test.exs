defmodule Elidactyl.Schemas.Server.CreateServerParamsTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.CreateServerParams
  import CreateServerParams

  @valid %{
    external_id: "external-id",
    name: "Building",
    user: 1,
    description: "server description",
    egg: 1,
    pack: 2,
    docker_image: "quay.io/pterodactyl/cire:java",
    startup: "java -Xms128M -Xmx128M -jar server.jar",
    environment: %{"BUNGEE_VERSION" => "latest", "SERVER_JARFILE" => "server.jar"},
    limits: %{memory: 128, swap: 0, disk: 512, io: 500, cpu: 100},
    feature_limits: %{databases: 5, allocations: 5, backups: 2},
    allocation: %{default: 17},
    start_on_completion: true,
    skip_scripts: false,
    oom_disabled: true
  }

  def build_changeset(params \\ %{}) do
    changeset(%CreateServerParams{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%CreateServerParams{}, %{})
      assert_invalid(changeset, :user, error_message == "can't be blank")
      assert_invalid(changeset, :egg, error_message == "can't be blank")
      assert_invalid(changeset, :docker_image, error_message == "can't be blank")
      assert_invalid(changeset, :startup, error_message == "can't be blank")
      assert_invalid(changeset, :environment, error_message == "can't be blank")
      assert_invalid(changeset, :limits, error_message == "can't be blank")
      assert_invalid(changeset, :feature_limits, error_message == "can't be blank")
      assert_invalid(changeset, :allocation, error_message == "can't be blank")
    end

    test "validates fields types" do
      %{external_id: 100} |> build_changeset() |> assert_invalid(:external_id)
      %{name: 100} |> build_changeset() |> assert_invalid(:name)
      %{user: "a"} |> build_changeset() |> assert_invalid(:user)
      %{description: 100} |> build_changeset() |> assert_invalid(:description)
      %{egg: "a"} |> build_changeset() |> assert_invalid(:egg)
      %{pack: "a"} |> build_changeset() |> assert_invalid(:pack)
      %{docker_image: true} |> build_changeset() |> assert_invalid(:docker_image)
      %{startup: 100} |> build_changeset() |> assert_invalid(:startup)
      %{environment: "a"} |> build_changeset() |> assert_invalid(:environment)
      %{limits: "a"} |> build_changeset() |> assert_invalid(:limits)
      %{feature_limits: "a"} |> build_changeset() |> assert_invalid(:feature_limits)
      %{allocation: "a"} |> build_changeset() |> assert_invalid(:allocation)
      %{start_on_completion: "a"} |> build_changeset() |> assert_invalid(:start_on_completion)
      %{skip_scripts: "a"} |> build_changeset() |> assert_invalid(:skip_scripts)
      %{oom_disabled: "a"} |> build_changeset() |> assert_invalid(:oom_disabled)
    end

    test "refutes external id if its length grater than 191" do
      %{external_id: String.pad_leading("", 192, "0")}
      |> build_changeset()
      |> assert_invalid(:external_id)
    end

    test "refutes name if its length grater than 255" do
      %{name: String.pad_leading("", 256, "0")} |> build_changeset() |> assert_invalid(:name)
    end

    test "refutes docker image if its length grater than 255" do
      %{docker_image: String.pad_leading("", 256, "0")}
      |> build_changeset()
      |> assert_invalid(:docker_image)
    end

    test "refutes negative pack values" do
      %{pack: -1} |> build_changeset() |> assert_invalid(:pack)
      %{pack: 0} |> build_changeset() |> assert_valid(:pack)
    end
  end
end
