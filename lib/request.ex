defmodule Elidactyl.Request do
  alias HTTPoison.Response
  alias HTTPoison.Error, as: PoisonError
  alias Elidactyl.Error

  def request(http_method, path, data \\ "", headers \\ []) do
    url = Application.get_env(:elidactyl, :pterodactyl_url) <> path
    headers = Keyword.merge(default_headers(), headers)
    options = [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 500]

    response =
      case http_method do
        :get ->
          get(url, headers, options)

        :post ->
          post(url, data, headers, options)

        :delete ->
          delete(url, headers, options)

        :put ->
          put(url, data, headers, options)
      end

    case handle_response(response) do
      {:ok, result} ->
        {:ok, result}
      {:error, _} = error ->
        error
    end
  end

  @spec post(any, any, any, any) :: any
  def post(url, body, headers \\ [], options \\ []) do
    case Poison.encode(body) do
      {:ok, encoded_body} ->
        HTTPoison.post(url, encoded_body, headers, options)
      {:error, error} ->
        {:error, %Error{type: :json_encode_failed, message: inspect(error)}}
    end
  end

  def get(url, headers \\ [], options \\ []) do
    HTTPoison.get(url, headers, options)
  end

  def delete(url, headers \\ [], options \\ []) do
    HTTPoison.delete(url, headers, options)
  end

  def put(url, body, headers \\ [], options \\ []) do
    HTTPoison.put(url, body, headers, options)
  end

  defp default_headers do
    token = Application.get_env(:elidactyl, :pterodactyl_auth_token)

    [
      {"Authorization", "Bearer #{token}"},
      {"Accept", "application/json; charset=utf-8"},
      {"Content-type", "application/json"}
    ]
  end

  def handle_response({:ok, %Response{status_code: 200, body: body}}) do
    case Poison.decode(body, keys: :atoms) do
      {:ok, body} ->
        {:ok, body}
      {:error, error} ->
        {:error, %Error{type: :json_decode_failed, message: inspect(error)}}
    end
  end

  def handle_response({:ok, %Response{status_code: code, body: body, request_url: url}}) do
    {
      :error,
      %Error{
        type: :http_request_failed,
        message: "Request to #{url} returned #{code}",
        details: %{
          code: code,
          body: body,
          url: url
        }
      }
    }
  end

  def handle_response({:error, %PoisonError{reason: reason}}) do
    {:error, %Error{type: :http_request_failed, message: inspect(reason)}}
  end
end
