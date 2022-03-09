defmodule Elidactyl.Utils do
  @moduledoc false

  @spec keys_to_atoms(map | keyword, atom | binary | [atom | binary]) :: %{optional(atom) => any}
  def keys_to_atoms(attributes, exclude \\ []) when is_map(attributes) do
    exclude = normalize_exclude(exclude)
    Map.new(attributes, &reduce_keys_to_atoms(&1, exclude))
  end

  @spec parse_timestamps(map) :: map
  def parse_timestamps(%{} = attributes) do
    attributes
    |> parse_timestamp(:created_at)
    |> parse_timestamp(:updated_at)
  end

  defp reduce_keys_to_atoms({key, val}, exclude) when is_map(val) do
    val =
      if key not in exclude do
        keys_to_atoms(val)
      else
        val
      end

    {String.to_existing_atom(key), val}
  end

  defp reduce_keys_to_atoms({key, val}, _) when is_list(val),
    do: {String.to_existing_atom(key), val}

  defp reduce_keys_to_atoms({key, val}, _), do: {String.to_existing_atom(key), val}

  defp normalize_exclude(exclude) when is_list(exclude) do
    exclude |> Enum.map(&to_string/1) |> Enum.uniq()
  end

  defp normalize_exclude(field) when is_atom(field) or is_binary(field) do
    [to_string(field)]
  end

  defp normalize_exclude(_), do: []

  defp parse_timestamp(attributes, field) do
    with value when is_binary(value) <- Map.get(attributes, field),
         {:ok, parsed} <- NaiveDateTime.from_iso8601(value) do
      Map.put(attributes, field, parsed)
    else
      _ -> attributes
    end
  end
end
