defmodule Elidactyl.Users do
  @moduledoc """
    This module is responsible for listing and modifying Pterodactyl users.
  """
  alias Elidactyl.Request
  alias Elidactyl.Error
  alias Elidactyl.User
  alias Elidactyl.Response

  @doc """
    Request all users from server.
  """
  @spec list_users() :: {:ok, [%User{}]} | {:error, %Error{}}
  def list_users do
    with {:ok, resp} <- Request.request(:get, "/api/application/users"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  @spec get_user_by_id(binary | integer) :: %User{}
  def get_user_by_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/users/#{id}"),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end

  @spec get_user_by_external_id(binary | integer) :: %User{}
  def get_user_by_external_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/users/external/#{id}"),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end


  @spec create_user(map) :: %User{}
  def create_user(params) do
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

  @spec edit_user(binary | integer, map) :: %User{}
  def edit_user(id, params) do
    with {:ok, %User{} = user} <- get_user_by_id(id),
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
end

