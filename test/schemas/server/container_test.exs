defmodule Elidactyl.Schemas.Server.ContainerTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.Container
  import Container

  @valid %{
    startup_command: "command",
    image: "image",
    environment: %{
      "VAR1" => "value1",
      "VAR2" => "value2",
    },
    installed: true,
  }

  def build_changeset(params \\ %{}) do
    changeset(%Container{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%Container{}, %{})
      assert_invalid(changeset, :startup_command, error_message == "can't be blank")
      assert_invalid(changeset, :image, error_message == "can't be blank")
      assert_invalid(changeset, :environment, error_message == "can't be blank")
    end

    test "allows optional fields to not present" do
      %Container{}
      |> changeset(Map.drop(@valid, ~w[installed]a))
      |> assert_valid()
    end

    test "validates fields types" do
      %{startup_command: 100} |> build_changeset() |> assert_invalid(:startup_command)
      %{image: 100} |> build_changeset() |> assert_invalid(:image)
      %{environment: 100} |> build_changeset() |> assert_invalid(:environment)
      %{installed: "a"} |> build_changeset() |> assert_invalid(:installed)
    end
  end
end
