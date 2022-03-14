defmodule Elidactyl.Application.Servers do
  @moduledoc false

  alias Elidactyl.Error
  alias Elidactyl.Request
  alias Elidactyl.Response
  alias Elidactyl.Schemas.Server
  alias Elidactyl.Schemas.Server.CreateServerParams
  alias Elidactyl.Schemas.Server.UpdateDetailsParams
  alias Elidactyl.Schemas.Server.UpdateBuildInfoParams
  alias Elidactyl.Schemas.Server.UpdateStartupParams

  @spec list_servers() :: {:ok, [Server.t()]} | {:error, Error.t()}
  def list_servers do
    with {:ok, resp} <- Request.request(:get, "/api/application/servers"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec get_server_by_id(Elidactyl.id()) :: {:ok, Server.t()} | {:error, Error.t()}
  def get_server_by_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/servers/#{id}"),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec get_server_by_external_id(Elidactyl.id()) :: {:ok, Server.t()} | {:error, Error.t()}
  def get_server_by_external_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/servers/external/#{id}"),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec create_server(Elidactyl.params()) :: {:ok, Server.t()} | {:error, Error.t()}
  def create_server(params) do
    with %{valid?: true} = changeset <-
           CreateServerParams.changeset(%CreateServerParams{}, params),
         %CreateServerParams{} = server <- Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:post, "/api/application/servers", server),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      %Ecto.Changeset{} = changeset -> {:error, Error.from_changeset(changeset)}
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec update_server_details(Elidactyl.id(), Elidactyl.params()) :: {:ok, Server.t()} | {:error, Error.t()}
  def update_server_details(id, params) do
    with %{valid?: true} = changeset <-
           UpdateDetailsParams.changeset(%UpdateDetailsParams{}, params),
         %UpdateDetailsParams{} = details <- Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <-
           Request.request(:patch, "/api/application/servers/#{id}/details", details),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      %Ecto.Changeset{} = changeset -> {:error, Error.from_changeset(changeset)}
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec delete_server(Elidactyl.id()) :: :ok | {:error, Error.t()}
  @spec delete_server(Elidactyl.id(), boolean) :: :ok | {:error, Error.t()}
  def delete_server(id, force \\ false) do
    with {:ok, _resp} <- Request.request(:delete, delete_path(id, force)) do
      :ok
    end
  end

  defp delete_path(id, true), do: "/api/application/servers/#{id}/force"
  defp delete_path(id, _), do: "/api/application/servers/#{id}"

  @spec update_server_build_info(Elidactyl.id(), Elidactyl.params()) ::
          {:ok, Server.t()} | {:error, Error.t()}
  def update_server_build_info(id, params) do
    with %{valid?: true} = changeset <-
           UpdateBuildInfoParams.changeset(%UpdateBuildInfoParams{}, params),
         %UpdateBuildInfoParams{} = params <- Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:patch, "/api/application/servers/#{id}/build", params),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      %Ecto.Changeset{} = changeset -> {:error, Error.from_changeset(changeset)}
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec update_server_startup(Elidactyl.id(), Elidactyl.params()) ::
          {:ok, Server.t()} | {:error, Error.t()}
  def update_server_startup(id, params) do
    with %{valid?: true} = changeset <-
           UpdateStartupParams.changeset(%UpdateStartupParams{}, params),
         %UpdateStartupParams{} = params <- Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:patch, "/api/application/servers/#{id}/startup", params),
         %Server{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      %Ecto.Changeset{} = changeset -> {:error, Error.from_changeset(changeset)}
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec suspend_server(Elidactyl.id()) :: :ok | {:error, Error.t()}
  def suspend_server(id) do
    with {:ok, _resp} <- Request.request(:post, "/api/application/servers/#{id}/suspend") do
      :ok
    end
  end

  @spec unsuspend_server(Elidactyl.id()) :: :ok | {:error, Error.t()}
  def unsuspend_server(id) do
    with {:ok, _resp} <- Request.request(:post, "/api/application/servers/#{id}/unsuspend") do
      :ok
    end
  end

  @spec reinstall_server(Elidactyl.id()) :: :ok | {:error, Error.t()}
  def reinstall_server(id) do
    with {:ok, _resp} <- Request.request(:post, "/api/application/servers/#{id}/reinstall") do
      :ok
    end
  end
end
