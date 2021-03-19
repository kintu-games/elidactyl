defmodule Elidactyl.MockedServer do
  @moduledoc false

  alias Elidactyl.MockedServer.Router
  alias Elidactyl.MockedServer.Factory
  alias Elidactyl.MockedServer.ExternalSchema.List, as: ExternalList
  alias Elidactyl.MockedServer.ExternalSchema.NullResource

  @objs ~w[server database nest egg egg_variable]a
  @type record :: %{
    required(:object) => binary,
    required(:attributes) => map,
  }

  @spec start :: {:ok, pid} | {:error, any}
  def start do
    Plug.Cowboy.http(Router, [], port: 8081)
  end

  @spec stop :: :ok | {:error, any}
  def stop do
    Plug.Cowboy.shutdown(Router.HTTP)
  end

  @spec get(Factory.obj, any) :: struct | NullResource
  def get(obj, id) when obj in @objs do
    storage_get({obj, id}, %NullResource{})
  end

  @spec list(Factory.obj) :: ExternalList.t
  def list(obj) when obj in @objs do
    data = {obj, :ids} |> storage_get([]) |> Enum.map(& storage_get({obj, &1}))
    %ExternalList{data: data}
  end

  @spec put(Factory.obj) :: struct
  @spec put(Factory.obj, Factory.attributes) :: struct
  def put(obj, attributes \\ %{}) when obj in @objs do
    %{attributes: %{id: id}} = record = Factory.build(obj, attributes)
    storage_put({obj, id}, record)
    storage_update({obj, :ids}, [], & Enum.uniq([id | &1]))
    record
  end

  @spec add_relationship(record, atom, any) :: record
  def add_relationship(%{attributes: attributes} = record, key, value) do
    rels = attributes |> Map.get(:relationships, %{}) |> Map.put(key, value)
    %{record | attributes: Map.put(attributes, :relationships, rels)}
  end

  @spec delete(Factory.obj, any) :: :ok
  def delete(obj, id) when obj in @objs do
    storage_delete({obj, id})
    storage_update({obj, :ids}, [], & List.delete(&1, id))
    :ok
  end

  @spec cleanup() :: :ok
  def cleanup do
    Enum.each(@objs, fn obj ->
      {obj, :ids} |> storage_get([]) |> Enum.each(& storage_delete({obj, &1}))
      storage_delete({obj, :ids})
    end)
    :ok
  end

  @spec storage_get(:persistent_term.key, :persistent_term.value) :: :persistent_term.value
  def storage_get(key, default \\ nil) do
    :persistent_term.get(key(key), default)
  end

  @spec storage_put(:persistent_term.key, :persistent_term.value) :: :ok
  def storage_put(key, value) do
    :persistent_term.put(key(key), value)
  end

  @spec storage_delete(:persistent_term.key) :: :ok
  def storage_delete(key) do
    :persistent_term.erase(key(key))
  end

  @spec storage_update(:persistent_term.key, any, (any -> :persistent_term.value)) :: :ok
  def storage_update(key, default, fun) do
    key = key(key)
    :persistent_term.put(key, fun.(:persistent_term.get(key, default)))
  end

  @spec key(any) :: {module, pid, any}
  def key(key) when is_tuple(key), do: key |> Tuple.insert_at(0, __MODULE__)# |> Tuple.insert_at(1, self())
  def key(key), do: {__MODULE__, key}# self(), key}
end
