defmodule Elidactyl.Client.Servers.Subusers do
  @moduledoc false

  alias Elidactyl.Error
  alias Elidactyl.Request
  alias Elidactyl.Response
  alias Elidactyl.Schemas.Server.SubuserV1

  @spec all(Elidactyl.uuid()) :: {:ok, [SubuserV1.t()]} | {:error, Error.t()}
  def all(server_uuid) do
    with {:ok, resp} <- Request.request(:get, "/api/client/servers/#{server_uuid}/users"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec create(Elidactyl.uuid(), Elidactyl.params()) :: {:ok, SubuserV1.t()} | {:error, Error.t()}
  def create(server_uuid, params) do
    with {:ok, resp} <-
           Request.request(:post, "/api/client/servers/#{server_uuid}/users", params),
         %SubuserV1{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec one(Elidactyl.uuid(), Elidactyl.uuid()) :: {:ok, SubuserV1.t()} | {:error, Error.t()}
  def one(server_uuid, subuser_uuid) do
    with {:ok, resp} <-
           Request.request(:get, "/api/client/servers/#{server_uuid}/users/#{subuser_uuid}"),
         %SubuserV1{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec update(Elidactyl.uuid(), Elidactyl.uuid(), Elidactyl.params()) ::
          {:ok, SubuserV1.t()} | {:error, Error.t()}
  def update(server_uuid, subuser_uuid, params) do
    with {:ok, resp} <-
           Request.request(
             :post,
             "/api/client/servers/#{server_uuid}/users/#{subuser_uuid}",
             params
           ),
         %SubuserV1{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec delete(Elidactyl.uuid(), Elidactyl.uuid()) :: :ok | {:error, Error.t()}
  def delete(server_uuid, subuser_uuid) do
    with {:ok, _resp} <-
           Request.request(:delete, "/api/client/servers/#{server_uuid}/users/#{subuser_uuid}") do
      :ok
    end
  end
end
