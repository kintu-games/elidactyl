defmodule Elidactyl.Application.Users do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Error
  alias Elidactyl.Schemas.User
  alias Elidactyl.Response

  @spec all() :: {:ok, [User.t]} | {:error, Error.t}
  def all do
    with {:ok, resp} <- Request.request(:get, "/api/application/users"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec get_by_id(Elidactyl.id) :: {:ok, User.t} | {:error, Error.t}
  def get_by_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/users/#{id}"),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec get_by_external_id(Elidactyl.id) :: {:ok, User.t} | {:error, Error.t}
  def get_by_external_id(id) do
    with {:ok, resp} <- Request.request(:get, "/api/application/users/external/#{id}"),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      _ -> {:error, Error.invalid_response()}
    end
  end


  @spec create(Elidactyl.params) :: {:ok, User.t} | {:error, Error.t}
  def create(params) do
    with %{valid?: true} = changeset <- User.changeset(%User{}, params),
         user = Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:post, "/api/application/users", user),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      %Ecto.Changeset{} = changeset -> {:error, Error.from_changeset(changeset)}
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec update(Elidactyl.id, Elidactyl.params) :: {:ok, User.t} | {:error, Error.t}
  def update(id, params) do
    with {:ok, %User{} = user} <- get_by_id(id),
         %{valid?: true} = changeset <- User.changeset(user, params),
         user = Ecto.Changeset.apply_changes(changeset),
         {:ok, resp} <- Request.request(:patch, "/api/application/users/#{id}", user),
         %User{} = result <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error -> error
      %Ecto.Changeset{} = changeset -> {:error, Error.from_changeset(changeset)}
      _ -> {:error, Error.invalid_response()}
    end
  end

  @spec delete(Elidactyl.id) :: :ok | {:error, Error.t}
  def delete(id) do
    with {:ok, _resp} <- Request.request(:delete, "/api/application/users/#{id}") do
      :ok
    end
  end
end
