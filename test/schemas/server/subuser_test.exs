defmodule Elidactyl.Schemas.Server.SubuserTest do
  use ExUnit.Case
  use Elidactyl.ChangesetCase

  alias Elidactyl.Schemas.Server.Subuser
  import Subuser

  @valid %{
    user_id: 1,
    server_id: 2,
  }

  def build_changeset(params \\ %{}) do
    changeset(%Subuser{}, Map.merge(@valid, params))
  end

  describe "changeset/2" do
    test "allows valid params" do
      build_changeset() |> assert_valid()
    end

    test "validates that mandatory fields are present" do
      changeset = changeset(%Subuser{}, %{})
      assert_invalid(changeset, :user_id, error_message == "can't be blank")
      assert_invalid(changeset, :server_id, error_message == "can't be blank")
    end

    test "validates fields types" do
      %{user_id: "a"} |> build_changeset() |> assert_invalid(:user_id)
      %{server_id: "a"} |> build_changeset() |> assert_invalid(:server_id)
    end
  end
end
