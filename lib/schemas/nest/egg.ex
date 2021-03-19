defmodule Elidactyl.Schemas.Nest.Egg do
  @moduledoc false

  alias Elidactyl.Response
  alias Elidactyl.Response.Parser
  alias Elidactyl.Utils

  @behaviour Parser

  defstruct ~w[
    id uuid name nest_id author description docker_image config startup script created_at updated_at
    nest servers variables]a

  @type t :: %__MODULE__{}

  @impl Parser
  def parse(%{"object" => "egg", "attributes" => attributes}) do
    attributes =
      attributes
      |> Map.put("nest_id", attributes["nest"])
      |> Map.drop(~w[nest])
      |> parse_relationships()
      |> Utils.keys_to_atoms(~w[config script relationships nest servers variables])
    struct(__MODULE__, attributes)
  end

  @relationships_atoms ~w[nest servers variables]a
  @relationships Enum.map(@relationships_atoms, &to_string/1)
  defp parse_relationships(%{"relationships" => %{} = rels} = attributes) do
    rels =
      rels
      |> Map.take(@relationships)
      |> Enum.into(%{}, fn {k, v} -> {String.to_existing_atom(k), Response.parse_response(v)} end)
    attributes
    |> Map.put("nest", Map.get(rels, :nest))
    |> Map.put("servers", Map.get(rels, :servers))
    |> Map.put("variables", Map.get(rels, :variables))
  end
  defp parse_relationships(%{"relationships" => _} = attributes), do: Map.delete(attributes, "relationships")
  defp parse_relationships(attributes), do: attributes
end
