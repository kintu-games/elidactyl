defmodule Elidactyl.Servers do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Response

  def list_servers do
#    GET https://pterodactyl.app/api/application/servers
    with {:ok, resp} <- Request.request(:get, "/api/application/servers"),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end
end