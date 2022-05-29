defmodule Elidactyl.Client.Servers do
  @moduledoc false

  alias Elidactyl.Error
  alias Elidactyl.Request
  alias Elidactyl.Response
  alias Elidactyl.Schemas.Server.Stats

  def list_all_servers do
    with {:ok, resp} <-
           Request.request(:get, "/api/client", "", [], use_client_api: true),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  def get_server_stats(server_identifier) do
    with {:ok, server_params} <-
           Request.request(:get, "/api/client/servers/#{server_identifier}", "", [],
             use_client_api: true
           ),
         :ok <- is_server_installed?(server_params),
         {:ok, resp} <-
           Request.request(:get, "/api/client/servers/#{server_identifier}/resources", "", [],
             use_client_api: true
           ),
         result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, :installation_in_progress} ->
        {:ok, %Stats{current_state: "installing"}}

      {:error, _} = error ->
        error

      _ ->
        {:error, Error.invalid_response()}
    end
  end

  defp is_server_installed?(params) do
    case Response.parse_response(params) do
      %{is_installing: false} -> :ok
      %{is_installing: _} -> {:error, :installation_in_progress}
      {:error, _} = error -> error
    end
  end
end
