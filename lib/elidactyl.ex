defmodule Elidactyl do
  @moduledoc """
  API for Pterodactyl panel
  """

  alias Elidactyl.Users

  @doc ~S"""
  Get all users.

  ## Examples
      iex> Elidactyl.get_all_users()
      {:ok, [%Elidactyl.Schemas.User{external_id: nil, password: nil, "2fa": false, created_at: "2018-03-18T15:15:17+00:00", email: "codeco@file.properties", first_name: "Rihan", id: 1, language: "en", last_name: "Arfan", root_admin: true, updated_at: "2018-10-16T21:51:21+00:00", username: "codeco", uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335"}, %Elidactyl.Schemas.User{"2fa": false, created_at: "2018-09-29T17:59:45+00:00", email: "wardle315@gmail.com", external_id: nil, first_name: "Harvey", id: 4, language: "en", last_name: "Wardle", password: nil, root_admin: false, updated_at: "2018-10-02T18:59:03+00:00", username: "wardledeboss", uuid: "f253663c-5a45-43a8-b280-3ea3c752b931"}]}
  """
  def get_all_users() do
    Users.list_users()
  end

  @doc ~S"""
  Create user with given params.

  ## Examples
      iex> params = %{
      ...>  username: "example",
      ...>  email: "example@example.com",
      ...>  first_name: "John",
      ...>  last_name: "Doe",
      ...>  language: "en",
      ...>  root_admin: false
      ...> }
      iex> Elidactyl.create_user(params)
      {:ok, %Elidactyl.Schemas.User{external_id: nil, password: nil, "2fa": false, created_at: "2018-03-18T15:15:17+00:00", email: "example@example.com", first_name: "John", id: 2, language: "en", last_name: "Doe", root_admin: false, updated_at: "2018-10-16T21:51:21+00:00", username: "example", uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335"}}
  """
  def create_user(params) do
    Users.create_user(params)
  end

  @doc ~S"""
  Update user using pterodactyl internal user id and params.

  ## Examples
      iex> params = %{
      ...>  email: "email@example.com",
      ...>  first_name: "John",
      ...>  last_name: "Doe",
      ...>  language: "en"
      ...> }
      iex> Elidactyl.update_user(1, params)
      {:ok, %Elidactyl.Schemas.User{external_id: nil, password: nil, "2fa": false, created_at: "2018-03-18T15:15:17+00:00", email: "email@example.com", first_name: "John", id: "1", language: "en", last_name: "Doe", root_admin: true, updated_at: "2018-10-16T21:51:21+00:00", username: "codeco", uuid: "c4022c6c-9bf1-4a23-bff9-519cceb38335"}}
  """
  def update_user(id, params) do
    Users.edit_user(id, params)
  end

  @doc ~S"""
  Delete user using internal pterodactyl user id.

  ## Examples
      iex> Elidactyl.delete_user(1)
      :ok
  """
  def delete_user(id) do
    Users.delete_user(id)
  end
end
