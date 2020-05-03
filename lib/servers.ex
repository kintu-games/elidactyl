defmodule Elidactyl.Servers do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Response
  alias Elidactyl.Server
  alias Elidactyl.Server.CreateParams

  def list_servers do
    #    GET https://pterodactyl.app/api/application/servers
    with {:ok, resp} <- Request.request(:get, "/api/application/servers"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  @spec get_server_by_id(binary | integer) :: %Server{}
  def get_server_by_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/servers/#{id}"),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  @spec get_server_by_external_id(binary | integer) :: %Server{}
  def get_server_by_external_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/servers/external/#{id}"),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end


  @spec create_server(map) :: %Server{}
  def create_server(params) do
    with %{valid?: true} = changeset <- CreateParams.changeset(%CreateParams{}, params),
         %CreateParams{} = server <- Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:post, "/api/application/servers", server),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

#  @spec edit_server(binary | integer, map) :: %Server{}
#  def edit_server(id, params) do
#    with {:ok, %Server{} = server} <- get_server_by_id(id),
#         %{valid?: true} = changeset <- Server.changeset(server, params),
#         %Server{} = server <- Ecto.Changeset.apply_changes(changeset),
#         {:ok, resp} <- Request.request(:patch, "/api/application/servers/#{id}", server),
#         %Server{} = result <- Response.parse_response(resp) do
#      {:ok, result}
#    else
#      {:error, _} = error ->
#        error
#    end
#  end
#
#    @spec delete_server(binary | integer) :: :ok
#    def delete_server(id) do
#      with {:ok, _resp} <- Request.request(:delete, "/api/application/servers/#{id}/") do
#        :ok
#      else
#        {:error, _} = error ->
#          error
#      end
#    end
  end