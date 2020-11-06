defmodule Elidactyl.Client.Servers.Subusers do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Response

  def all(server_uuid) do
    with {:ok, resp} <- Request.request(:get, "/api/client/servers/#{server_uuid}/users"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  def create(server_uuid, params) do
    with {:ok, resp} <- Request.request(:post, "/api/client/servers/#{server_uuid}/users", params),
         result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  def one(server_uuid, subuser_uuid) do
    with {:ok, resp} <- Request.request(:get, "/api/client/servers/#{server_uuid}/users/#{subuser_uuid}"),
         result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  def update(server_uuid, subuser_uuid, params) do
    with {:ok, resp} <- Request.request(:post, "/api/client/servers/#{server_uuid}/users/#{subuser_uuid}", params),
         result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  def delete(server_uuid, subuser_uuid) do
    with {:ok, resp} <- Request.request(:delete, "/api/client/servers/#{server_uuid}/users/#{subuser_uuid}"),
         result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end
end