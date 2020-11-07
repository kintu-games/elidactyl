defmodule Elidactyl.Users do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Error
  alias Elidactyl.Schemas.User
  alias Elidactyl.Response

  @spec all() :: {:ok, [User.t()]} | {:error, Error.t()}
  def all do
    with {:ok, resp} <- Request.request(:get, "/api/application/users"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  @spec get_by_id(binary | integer) :: User.t()
  def get_by_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/users/#{id}"),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  @spec get_by_external_id(binary | integer) :: User.t()
  def get_by_external_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/users/external/#{id}"),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end


  @spec create(map) :: User.t()
  def create(params) do
    with %{valid?: true} = changeset <- User.changeset(%User{}, params),
         %User{} = user <- Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:post, "/api/application/users", user),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  @spec update(binary | integer, map) :: User.t()
  def update(id, params) do
    with {:ok, %User{} = user} <- get_by_id(id),
         %{valid?: true} = changeset <- User.changeset(user, params),
         %User{} = user <- Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:patch, "/api/application/users/#{id}", user),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  @spec delete(binary | integer) :: :ok
  def delete(id) do
    with {:ok, _resp} <- Request.request(:delete, "/api/application/users/#{id}") do
      :ok
    else
      {:error, _} = error ->
        error
    end
  end
end

