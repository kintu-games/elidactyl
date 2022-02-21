defmodule Elidactyl.MockedServer.Factory do
  @moduledoc false

  alias Elidactyl.Factory
  alias Elidactyl.MockedServer.ExternalSchema.Server
  alias Elidactyl.MockedServer.ExternalSchema.Server.Database
  alias Elidactyl.MockedServer.ExternalSchema.ServerSubuser
  alias Elidactyl.MockedServer.ExternalSchema.Nest
  alias Elidactyl.MockedServer.ExternalSchema.Nest.Egg
  alias Elidactyl.MockedServer.ExternalSchema.Nest.EggVariable
  alias Elidactyl.MockedServer.ExternalSchema.Node
  alias Elidactyl.MockedServer.ExternalSchema.Node.Allocation
  alias Elidactyl.MockedServer.ExternalSchema.User

  @type obj :: :server | :database | :nest | :egg | :egg_variable | :user | :server_subuser | :node | :node_created_response | :allocation
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
  defp module_for(:user), do: User
  defp module_for(:server_subuser), do: ServerSubuser
  defp module_for(:node), do: Node
  defp module_for(:node_created_response), do: Node
  defp module_for(:allocation), do: Allocation
end
