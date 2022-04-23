defmodule Elidactyl.Behaviour do
  @moduledoc false

  alias Elidactyl.Schemas.Node
  alias Elidactyl.Schemas.Node.Allocation
  alias Elidactyl.Schemas.Server
  alias Elidactyl.Schemas.Server.Stats
  alias Elidactyl.Schemas.User
  alias Elidactyl.Error

  @type id :: binary | non_neg_integer
  @type wings_identifier :: binary
  @type params :: map
  @type external_id :: binary | integer
  @type uuid :: Ecto.UUID.t()

  @callback get_all_users() :: {:ok, [User.t()]} | {:error, Error.t()}
  @callback get_all_servers() :: {:ok, [Server.t()]} | {:error, Error.t()}
  @callback create_user(params) :: {:ok, User.t()} | {:error, Error.t()}
  @callback get_user_by_external_id(external_id) :: {:ok, User.t()} | {:error, Error.t()}
  @callback update_user(id, params) :: {:ok, User.t()} | {:error, Error.t()}
  @callback delete_user(id) :: :ok | {:error, Error.t()}

  @callback create_server(params) :: {:ok, Server.t()} | {:error, Error.t()}
  @callback get_server(id) :: {:ok, Server.t()} | {:error, Error.t()}
  @callback delete_server(id) :: :ok | {:error, Error.t()}
  @callback update_server_details(id, params) :: {:ok, Server.t()} | {:error, Error.t()}
  @callback get_server_stats(wings_identifier) :: {:ok, Stats.t()} | {:error, Error.t()}

  @callback create_node(params) :: {:ok, Node.t()} | {:error, Error.t()}
  @callback get_node(id) :: {:ok, Node.t()} | {:error, Error.t()}

  @callback list_allocations(id) :: {:ok, [Allocation.t()]} | {:error, Error.t()}
end
