defmodule Elidactyl.NodesTest do
  use ExUnit.Case
  alias Elidactyl.Nodes
  alias Elidactyl.Schemas.Node
  alias Elidactyl.Schemas.Node.Allocation

  test "list allocations for a node" do
    assert {:ok, allocations} = Nodes.list_allocations(1)
    assert [
             %Allocation{
               alias: "steam",
               assigned: false,
               id: 1,
               ip: "1.2.3.4",
               port: 1000
             },
             %Allocation{
               alias: "rcon",
               assigned: false,
               id: 2,
               ip: "1.2.3.4",
               port: 2000
             }
           ] == allocations
  end

  test "get node configuration" do
    assert {:ok, configuration} = Nodes.get_configuration(1)
    assert %{
      "debug" => false,
      "uuid" => "1046d1d1-b8ef-4771-82b1-2b5946d33397",
      "token_id" => "iAcosCn1KCAgVjVO",
      "token" => "FanPzLCptUxkGow3vi7Z",
      "api" => %{
        "host" => "0.0.0.0",
        "port" => 8080,
        "ssl" => %{
          "enabled" => true,
          "cert" => "/etc/letsencrypt/live/pterodactyl.file.properties/fullchain.pem",
          "key" => "/etc/letsencrypt/live/pterodactyl.file.properties/privkey.pem",
        },
        "upload_limit" => 100,
      },
      "system" => %{
        "data" => "/srv/daemon-data",
        "sftp" => %{"bind_port" => 2022}
      },
      "remote" => "https://pterodactyl.file.properties",
    } == configuration
  end

  test "get node" do
    assert {:ok, node} = Nodes.get(1)
    assert %Node{
      id: 1,
      uuid: "1046d1d1-b8ef-4771-82b1-2b5946d33397",
      public: true,
      name: "Test",
      description: "Test",
      location_id: 1,
      fqdn: "pterodactyl.file.properties",
      scheme: "https",
      behind_proxy: false,
      maintenance_mode: false,
      memory: 2048,
      memory_overallocate: 0,
      disk: 5000,
      disk_overallocate: 0,
      upload_size: 100,
      daemon_listen: 8080,
      daemon_sftp: 2022,
      daemon_base: "/srv/daemon-data",
      created_at: "2019-12-22T04:44:51+00:00",
      updated_at: "2019-12-22T04:44:51+00:00",
    } == node
  end
end
