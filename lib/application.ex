defmodule Elidactyl.Application do
  @moduledoc false
  use Application

  alias Elidactyl.Repo.Supervisor, as: Repo

  def start(_type, args) do
    children = case args do
      [env: :prod] -> [Repo]
      [env: :test] -> [Repo, {Plug.Cowboy, scheme: :http, plug: Elidactyl.MockServer, options: [port: 8081]}]
      [env: :dev] -> [Repo]
      [_] -> [Repo]
    end

    opts = [strategy: :one_for_one, name: Elidactyl.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
