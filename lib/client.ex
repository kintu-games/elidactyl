defmodule Elidactyl.Client do
  @moduledoc """
  Retrieves all servers that the user has access to, along with information about them.
  """

  alias Elidactyl.Request
  alias Elidactyl.Response

  def list_all_servers do
    with {:ok, resp} <- Request.request(:get, "/api/client"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end
end