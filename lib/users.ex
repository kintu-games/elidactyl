defmodule Elidactyl.Users do
  @moduledoc """
    This module is responsible for listing and modifying Pterodactyl users.
  """
  alias Elidactyl.List
  alias Elidactyl.Request
  alias Elidactyl.Response

  def list_users do
    with {:ok, resp} <- Request.request(:get, "/api/application/users"),
         %List{} = result <- Response.parse_response(resp) do
      result
    end
  end
end

