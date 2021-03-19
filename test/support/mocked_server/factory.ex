defmodule Elidactyl.MockedServer.Factory do
  @moduledoc false

  alias Elidactyl.Factory
  alias Elidactyl.MockedServer.ExternalSchema.Server
  alias Elidactyl.MockedServer.ExternalSchema.Server.Database
  alias Elidactyl.MockedServer.ExternalSchema.Nest
  alias Elidactyl.MockedServer.ExternalSchema.Nest.Egg
  alias Elidactyl.MockedServer.ExternalSchema.Nest.EggVariable

  @type obj :: :server | :database | :nest | :egg | :egg_variable
  @type attributes :: map | keyword

  @spec build(obj, attributes) :: struct
  def build(obj, attributes) do
    attributes = Factory.build(obj, attributes)
    obj |> module_for() |> struct(attributes: attributes)
  end

  defp module_for(:server), do: Server
  defp module_for(:database), do: Database
  defp module_for(:nest), do: Nest
  defp module_for(:egg), do: Egg
  defp module_for(:egg_variable), do: EggVariable
end
