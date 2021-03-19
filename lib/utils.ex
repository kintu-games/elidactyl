defmodule Elidactyl.Utils do
  @moduledoc false

  def keys_to_atoms(attributes, exclude \\ []) when is_map(attributes) do
    exclude = normalize_exclude(exclude)
    Map.new(attributes, & reduce_keys_to_atoms(&1, exclude))
  end

  def reduce_keys_to_atoms({key, val}, exclude) when is_map(val) do
    val =
      if key not in exclude do
        keys_to_atoms(val)
      else
        val
      end
    {String.to_existing_atom(key), val}
  end
  def reduce_keys_to_atoms({key, val}, _) when is_list(val), do: {String.to_existing_atom(key), val}
  def reduce_keys_to_atoms({key, val}, _), do: {String.to_existing_atom(key), val}

  defp normalize_exclude(exclude) when is_list(exclude) do
    exclude |> Enum.map(&to_string/1) |> Enum.uniq()
  end
  defp normalize_exclude(field) when is_atom(field) or is_binary(field) do
    [to_string(field)]
  end
  defp normalize_exclude(_), do: []
end
