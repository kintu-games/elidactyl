# Elidactyl

Elixir API client to Pterodactyl - opensource dedicated game server management system.

Supports Pterodactyl API V1.
https://dashflo.net/docs/api/pterodactyl/v1/

You can find documentation here https://hexdocs.pm/elidactyl/Elidactyl.html

## Installation

=)

Add `elidactyl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elidactyl, "~> 0.6.0"}
  ]
end
```

## Configuration

```elixir
config :elidactyl, :pterodactyl_url, "<pterodactyl_ip:port>"
config :elidactyl, :pterodactyl_server_auth_token, "<pterodactyl_global_auth_token>"
# You can generate global API token at this page:
# https://<pterodactyl_url>/admin/api
```

## How to use

### List available servers

```elixir
iex> Elidactyl.list_all_servers()
{:ok,
 [
   %Elidactyl.Server{
     allocation: nil,
     container: nil,
     created_at: nil,
     description: "Custom rust server",
     egg: nil,
     external_id: nil,
     feature_limits: %{allocations: 0, databases: 0},
     id: nil,
     identifier: "4b5a38fa",
     limits: %{cpu: 0, disk: 30000, io: 250, memory: 6000, swap: 0},
     name: "Rust server",
     nest: nil,
     node: nil,
     pack: nil,
     server_owner: true,
     suspended: nil,
     updated_at: nil,
     user: nil,
     uuid: "4b5a38fa-c61a-4fbf-bfd5-f21a2f463b37"
   }
 ]
}
```

### List all users

```elixir
iex> Elidactyl.get_all_users()
{:ok,
 [
   %Elidactyl.Schemas.User{
     "2fa": true,
     created_at: "2020-03-10T20:37:04+00:00",
     email: "r378ut@gmail.com",
     external_id: nil,
     first_name: "Roman",
     id: 1,
     language: "en",
     last_name: "Berdichevskii",
     password: nil,
     root_admin: true,
     updated_at: "2020-03-14T23:03:54+00:00",
     username: "kintull",
     uuid: "6f0d5bfc-ea4b-41ee-afb9-616d755c70ac"
   }
 ]}
```

### Create new User

```elixir
iex(2)> params =
  %{
    email: "example@example.com",
    first_name: "John",
    is_admin: true,
    language: "en",
    last_name: "Doe",
    root_admin: false,
    username: "example"
  }
iex(3)> Elidactyl.Application.Users.create_user(params)

{:ok,
 %Elidactyl.Schemas.User{
   "2fa": false,
   created_at: "2020-05-30T13:19:42+00:00",
   email: "example@example.com",
   external_id: nil,
   first_name: "John",
   id: 18,
   language: "en",
   last_name: "Doe",
   password: nil,
   root_admin: false,
   updated_at: "2020-05-30T13:19:42+00:00",
   username: "example",
   uuid: "219e20e3-3975-44b4-ae63-fa79137fdb99"
 }}
```

### Create new Node

```elixir
params =
  %{
     daemon_listen: 8080,
     daemon_sftp: 2022,
     disk: 1024,
     disk_overallocate: 0,
     fqdn: "node.example.com",
     location_id: 1,
     memory: 1024,
     memory_overallocate: 0,
     name: "node",
     scheme: "http",
     upload_size: 100
     }
iex> Elidactyl.create_node(params)
{:ok,
  %Elidactyl.Schemas.Node{
   behind_proxy: true,
   created_at: ~N[2022-01-16 23:36:57.343035],
   daemon_base: "/srv/daemon-data",
   daemon_listen: 8080,
   daemon_sftp: 2022,
   description: "Test",
   disk: 1024,
   disk_overallocate: 0,
   fqdn: "node.example.com",
   id: 562,
   location_id: 1,
   maintenance_mode: false,
   memory: 1024,
   memory_overallocate: 0,
   name: "node",
   public: false,
   scheme: "http",
   updated_at: ~N[2022-02-12 23:36:57.343035],
   upload_size: 100,
   uuid: "e543674f-3d37-445a-90e8-e5c47b05c7e9"
}}
```
