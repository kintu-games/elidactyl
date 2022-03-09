defmodule Elidactyl.TestApplication do
  @moduledoc false
  use Application

  def start(_type, args) do
    children =
      case args do
        [env: :test] ->
          [
            {Plug.Cowboy,
             scheme: :http, plug: Elidactyl.MockedServer.Router, options: [port: 8081]}
          ]

        [_] ->
          []
      end

    opts = [strategy: :one_for_one, name: Elidactyl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
