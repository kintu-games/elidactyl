defmodule Elidactyl.Client do
  @moduledoc false

  alias Elidactyl.Client.Servers.Subusers
  alias Elidactyl.Client.Servers
  alias Elidactyl.Error
  alias Elidactyl.Schemas.Server
  alias Elidactyl.Schemas.Server.Stats
  alias Elidactyl.Schemas.Server.SubuserV1

  @spec list_all_servers :: {:ok, [Server.t()]} | {:error, Error.t()}
  defdelegate list_all_servers, to: Servers

  @spec get_server_stats(Elidactyl.wings_identifier()) :: {:ok, Stats.t()} | {:error, Error.t()}
  defdelegate get_server_stats(server_identifier), to: Servers

  @spec list_all_server_subusers(Elidactyl.uuid()) :: {:ok, [SubuserV1.t()]} | {:error, Error.t()}
  defdelegate list_all_server_subusers(server_uuid), to: Subusers, as: :all

  @spec create_server_subuser(Elidactyl.uuid(), Elidactyl.params()) ::
          {:ok, SubuserV1.t()} | {:error, Error.t()}
  defdelegate create_server_subuser(server_uuid, params), to: Subusers, as: :create

  @spec get_server_subuser(Elidactyl.uuid(), Elidactyl.uuid()) ::
          {:ok, SubuserV1.t()} | {:error, Error.t()}
  defdelegate get_server_subuser(server_uuid, subuser_uuid), to: Subusers, as: :one

  @spec update_server_subuser(Elidactyl.uuid(), Elidactyl.uuid(), Elidactyl.params()) ::
          {:ok, SubuserV1.t()}
          | {:error, Error.t()}
  defdelegate update_server_subuser(server_uuid, subuser_uuid, params), to: Subusers, as: :update

  @spec delete_server_subuser(Elidactyl.uuid(), Elidactyl.uuid()) :: :ok | {:error, Error.t()}
  defdelegate delete_server_subuser(server_uuid, subuser_uuid), to: Subusers, as: :delete
end
