defmodule Elidactyl.Utils do
  @moduledoc false

  def keys_to_atoms(attributes) when is_map(attributes) do
    Map.new(attributes, &reduce_keys_to_atoms/1)
  end

  def reduce_keys_to_atoms({key, val}) when is_map(val), do: {String.to_existing_atom(key), keys_to_atoms(val)}
#  def reduce_keys_to_atoms({key, val}) when is_list(val), do: {String.to_existing_atom(key), Enum.map(val, &keys_to_atoms(&1))}
  def reduce_keys_to_atoms({key, val}) when is_list(val), do: {String.to_existing_atom(key), val}
  def reduce_keys_to_atoms({key, val}), do: {String.to_existing_atom(key), val}
end