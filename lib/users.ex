defmodule Elidactyl.Users do
  @moduledoc """
    This module is responsible for listing and modifying Pterodactyl users.
  """
  alias Elidactyl.Request
  alias Elidactyl.Response

  def list_users do
    with {:ok, resp} <- Request.request(:get, "/api/application/users"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end
end

