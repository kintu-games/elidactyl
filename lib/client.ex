defmodule Elidactyl.Client do
  @moduledoc false

  alias Elidactyl.Request
  alias Elidactyl.Response

  def list_all_servers do
    with {:ok, resp} <- Request.request(:get, "/api/client", "", [], use_client_api: true),
         result when is_list(result) <- Response.parse_response(resp) do
      {:ok, result}
    else
      {:error, _} = error ->
        error
    end
  end
end