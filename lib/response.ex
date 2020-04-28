defmodule Elidactyl.Response do
  alias Elidactyl.List
  alias Elidactyl.User

  def parse_response(%{object: object} = resp) do
    mod = get_object_mod(object)
    :erlang.apply(mod, :parse, [resp])
  end

  defp get_object_mod("list"), do: List
  defp get_object_mod("user"), do: User
end
