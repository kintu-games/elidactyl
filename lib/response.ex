defmodule Elidactyl.Response do
  @moduledoc false

  alias Elidactyl.Schemas.List
  alias Elidactyl.Schemas.Server
  alias Elidactyl.Schemas.User
  alias Elidactyl.Schemas.Node.Allocation

  def parse_response(%{"object" => object} = resp) do
    mod = get_object_mod(object)
    :erlang.apply(mod, :parse, [resp])
  end

  defp get_object_mod("list"), do: List
  defp get_object_mod("user"), do: User
  defp get_object_mod("server"), do: Server
  defp get_object_mod("allocation"), do: Allocation
end
