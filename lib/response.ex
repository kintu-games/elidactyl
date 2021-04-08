defmodule Elidactyl.Response do
  @moduledoc false

  alias Elidactyl.Schemas.List
  alias Elidactyl.Schemas.Nest
  alias Elidactyl.Schemas.Nest.Egg
  alias Elidactyl.Schemas.Nest.EggVariable
  alias Elidactyl.Schemas.Node
  alias Elidactyl.Schemas.Node.Allocation
  alias Elidactyl.Schemas.Server
  alias Elidactyl.Schemas.Server.Database
  alias Elidactyl.Schemas.Server.SubuserV1
  alias Elidactyl.Schemas.User
  alias Elidactyl.Schemas.Node.Allocation
  alias Elidactyl.Schemas.Nest
  alias Elidactyl.Schemas.Nest.Egg
  alias Elidactyl.Schemas.Nest.EggVariable

  @type json_map :: %{binary => any}

  defmodule Parser do
    @callback parse(Elidactyl.Response.json_map) :: any
  end

  @spec parse_response(json_map | binary) :: any
  @spec parse_response(json_map | binary, module | nil) :: any
  def parse_response(map, mod \\ nil)
  def parse_response("", _), do: ""
  def parse_response(%{"object" => "null_response", "attributes" => nil}, _), do: nil
  def parse_response(%{"object" => object} = resp, _) do
    mod = get_object_mod(object)
    apply(mod, :parse, [resp])
  end
  def parse_response(resp, mod) do
    apply(mod, :parse, [resp])
  end

  defp get_object_mod("list"), do: List
  defp get_object_mod("node"), do: Node
  defp get_object_mod("egg"), do: Egg
  defp get_object_mod("egg_variable"), do: EggVariable
  defp get_object_mod("nest"), do: Nest
  defp get_object_mod("user"), do: User
  defp get_object_mod("server"), do: Server
  defp get_object_mod("allocation"), do: Allocation
  defp get_object_mod("databases"), do: Database
  defp get_object_mod("server_subuser"), do: SubuserV1
end
