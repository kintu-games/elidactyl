defmodule Elidactyl.Response do
  @moduledoc false

  alias Elidactyl.Schemas.List
  alias Elidactyl.Schemas.Node
  alias Elidactyl.Schemas.Server
  alias Elidactyl.Schemas.Server.Database
  alias Elidactyl.Schemas.User
  alias Elidactyl.Schemas.Node.Allocation

  alias Elidactyl.Schemas.Server.SubuserV1

  def parse_response(%{"object" => object} = resp) do
    mod = get_object_mod(object)
    :erlang.apply(mod, :parse, [resp])
  end
  def parse_response(""), do: ""

  defp get_object_mod("list"), do: List
  defp get_object_mod("node"), do: Node
  defp get_object_mod("user"), do: User
  defp get_object_mod("server"), do: Server
  defp get_object_mod("allocation"), do: Allocation
  defp get_object_mod("databases"), do: Database
  defp get_object_mod("server_subuser"), do: SubuserV1
end
