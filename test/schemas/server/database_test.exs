defmodule Elidactyl.Schemas.Server.DatabaseTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.Database
  import Database

  @valid %{
    host: 2,
    database: "db",
    remote: "%"
  }

  def build_changeset(params \\ %{}) do
    changeset(%Database{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%Database{}, %{})
      assert_invalid(changeset, :host, error_message == "can't be blank")
      assert_invalid(changeset, :database, error_message == "can't be blank")
      assert_invalid(changeset, :remote, error_message == "can't be blank")
    end

    test "validates fields types" do
      %{host: "a"} |> build_changeset() |> assert_invalid(:host)
      %{database: 100} |> build_changeset() |> assert_invalid(:database)
      %{remote: 100} |> build_changeset() |> assert_invalid(:remote)
    end
  end
end
