defmodule Elidactyl.Client do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Response
  alias Elidactyl.Client.Servers.Subusers

  def list_all_servers do
    with {:ok, resp} <- Request.request(:get, "/api/client", "", [], use_client_api: true),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  def list_all_server_subusers(server_uuid) do
    Subusers.all(server_uuid)
  end

  def create_server_subuser(server_uuid, params) do
    Subusers.create(server_uuid, params)
  end

  def get_server_subuser(server_uuid, subuser_uuid) do
    Subusers.one(server_uuid, subuser_uuid)
  end

  def update_server_subuser(server_uuid, subuser_uuid, params) do
    Subusers.update(server_uuid, subuser_uuid, params)
  end

  def delete_server_subuser(server_uuid, subuser_uuid) do
    Subusers.delete(server_uuid, subuser_uuid)
  end
end