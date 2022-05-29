defmodule Elidactyl.Client.Server.ClientTest do
  use ExUnit.Case, async: false
  use Elidactyl.RequestCase

  alias Elidactyl.MockedServer
  alias Elidactyl.Client

  describe "get_server_stats/1" do
    test "get usage stats for a running server" do
      %{attributes: server} = MockedServer.put(:server, is_installing: false)
      MockedServer.put(:stats, %{server: server.id})

      assert {:ok, result} = Client.get_server_stats(server.id)
      refute "installing" == result.current_state
    end

    test "get usage stats for an installing server" do
      %{attributes: server} = MockedServer.put(:server, is_installing: true)

      assert {:ok, result} = Client.get_server_stats(server.id)
      assert "installing" == result.current_state
    end
  end
end
