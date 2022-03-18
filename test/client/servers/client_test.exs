defmodule Elidactyl.Client.Server.ClientTest do
  use ExUnit.Case, async: false
  use Elidactyl.RequestCase

  alias Elidactyl.MockedServer
  alias Elidactyl.Schemas.Server.Stats
  alias Elidactyl.Client

  setup do
    %{attributes: server} = MockedServer.put(:server)
    MockedServer.put(:stats, %{server: server.id})

    %{server: server}
  end

  describe "get_server_stats/1" do
    test "get usage stats for a server", %{server: server} do
      assert {:ok, %Stats{}} = Client.get_server_stats(server.id)
    end
  end
end
