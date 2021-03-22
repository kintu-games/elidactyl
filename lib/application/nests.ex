defmodule Elidactyl.Application.Nests do
  @moduledoc false

  alias Elidactyl.Error
  alias Elidactyl.Request
  alias Elidactyl.Response
  alias Elidactyl.Schemas.Nest.Egg

  @type id :: integer | binary
  @type egg_includes :: [:nest | :servers | :config | :script | :variables]

  @spec list_eggs(id) :: {:ok, [Egg.t]} | {:error, Error.t}
  @spec list_eggs(id, egg_includes) :: {:ok, [Egg.t]} | {:error, Error.t}
  def list_eggs(nest_id, includes \\ []) do
    includes = make_includes(includes)
    with {:ok, resp} <- Request.request(:get, "/api/application/nests/#{nest_id}/eggs#{includes}"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    end
  end

  @spec egg(id, id) :: {:ok, Egg.t} | {:error, Error.t}
  @spec egg(id, id, egg_includes) :: {:ok, Egg.t} | {:error, Error.t}
  def egg(nest_id, egg_id, includes \\ []) do
    includes = make_includes(includes)
    with {:ok, resp} <- Request.request(:get, "/api/application/nests/#{nest_id}/eggs/#{egg_id}#{includes}"),
         %Egg{} = result <- Response.parse_response(resp) do
      {:ok, result}
    end
  end

  @includes ~w[nest servers config script variables]a
  defp make_includes([_ | _] = includes) do
    includes =
      includes
      |> Enum.uniq()
      |> Enum.filter(& &1 in @includes)
      |> Enum.map(&to_string/1)
      |> Enum.join(",")
    "?include=" <> includes
  end
  defp make_includes(_), do: ""
end
