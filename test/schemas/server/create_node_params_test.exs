defmodule Elidactyl.Schemas.Server.CreateNodeParamsTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Node.CreateNodeParams
  import CreateNodeParams

  @valid %{
    name: "node",
    location_id: 1,
    fqdn: "node.example.com",
    scheme: "http",
    memory: 1024,
    memory_overallocate: 0,
    disk: 1024,
    disk_overallocate: 0,
    upload_size: 100,
    daemon_sftp: 2022,
    daemon_listen: 8080,
  }

  def build_changeset(params \\ %{}) do
    changeset(%CreateNodeParams{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%CreateNodeParams{}, %{})
      assert_invalid(changeset, :name, error_message == "can't be blank")
      assert_invalid(changeset, :location_id, error_message == "can't be blank")
      assert_invalid(changeset, :fqdn, error_message == "can't be blank")
      assert_invalid(changeset, :scheme, error_message == "can't be blank")
      assert_invalid(changeset, :memory, error_message == "can't be blank")
      assert_invalid(changeset, :memory_overallocate, error_message == "can't be blank")
      assert_invalid(changeset, :disk, error_message == "can't be blank")
      assert_invalid(changeset, :disk_overallocate, error_message == "can't be blank")
      assert_invalid(changeset, :upload_size, error_message == "can't be blank")
      assert_invalid(changeset, :daemon_sftp, error_message == "can't be blank")
      assert_invalid(changeset, :daemon_listen, error_message == "can't be blank")
    end

    test "validates fields types" do
      %{name: 100} |> build_changeset() |> assert_invalid(:name)
      %{location_id: "a"} |> build_changeset() |> assert_invalid(:location_id)
      %{fqdn: 100} |> build_changeset() |> assert_invalid(:fqdn)
      %{scheme: 1} |> build_changeset() |> assert_invalid(:scheme)
      %{memory: "a"} |> build_changeset() |> assert_invalid(:memory)
      %{memory_overallocate: "a"} |> build_changeset() |> assert_invalid(:memory_overallocate)
      %{disk: "a"} |> build_changeset() |> assert_invalid(:disk)
      %{disk_overallocate: "a"} |> build_changeset() |> assert_invalid(:disk_overallocate)
      %{upload_size: "a"} |> build_changeset() |> assert_invalid(:upload_size)
      %{daemon_sftp: "a"} |> build_changeset() |> assert_invalid(:daemon_sftp)
      %{daemon_listen: "a"} |> build_changeset() |> assert_invalid(:daemon_listen)
    end

    test "refuses if integer fields are less than 0" do
      %{memory: -1} |> build_changeset() |> assert_invalid(:memory)
      %{memory_overallocate: -1} |> build_changeset() |> assert_invalid(:memory_overallocate)
      %{disk: -1} |> build_changeset() |> assert_invalid(:disk)
      %{disk_overallocate: -1} |> build_changeset() |> assert_invalid(:disk_overallocate)
      %{upload_size: -1} |> build_changeset() |> assert_invalid(:upload_size)
    end

    test "refuses if string field length is more than expected" do
      %{name: String.pad_leading("", 256, "a")} |> build_changeset() |> assert_invalid(:name)
      %{fqdn: String.pad_leading("", 256, "a")} |> build_changeset() |> assert_invalid(:fqdn)
      %{scheme: String.pad_leading("", 256, "a")} |> build_changeset() |> assert_invalid(:scheme)
    end
  end
end
