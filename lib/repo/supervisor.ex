defmodule Elidactyl.Repo.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init([Elidactyl.PanelRepo], strategy: :one_for_one)
  end
end
