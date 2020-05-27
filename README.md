# Elidactyl

Elixir API client to Pterodactyl - opensource dedicated game server managment system

## Installation

Add `elidactyl` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elidactyl, "~> 0.1.0"}
  ]
end
```

## Configuration
```elixir
config :elidactyl, :pterodactyl_url, "<your_ip_here>"
config :elidactyl, :pterodactyl_auth_token, "<your_auth_token>"
```

Auth token is generated on this page:
`http://<your_ip_here>/account/api`

## How to use

# List available servers
```elixir
iex(1)> Elidactyl.Client.list_all_servers()
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

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elidactyl](https://hexdocs.pm/elidactyl).

