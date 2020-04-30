defmodule Elidactyl.Request do
  alias HTTPoison.Response
  alias HTTPoison.Error, as: HTTPError
  alias Elidactyl.Error

  @spec request(atom, binary, any, [{binary, binary}]) :: {:ok, binary} | {:error, Error.t()}
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

        :patch ->
          patch(url, data, headers, options)
      end

    case handle_response(response) do
      {:ok, result} ->
        {:ok, result}
      {:error, _} = error ->
        error
    end
  end

  @spec post(binary, any, list, list) :: any
  def post(url, body, headers \\ [], options \\ []) do
    case Poison.encode(body) do
      {:ok, encoded_body} ->
        HTTPoison.post(url, encoded_body, headers, options)
      {:error, error} ->
        {:error, %Error{type: :json_encode_failed, message: inspect(error)}}
    end
  end

  @spec get(binary, list, list) :: any
  def get(url, headers \\ [], options \\ []) do
    HTTPoison.get(url, headers, options)
  end

  @spec delete(binary, list, list) :: any
  def delete(url, headers \\ [], options \\ []) do
    HTTPoison.delete(url, headers, options)
  end

  @spec put(binary, any, list, list) :: any
  def put(url, body, headers \\ [], options \\ []) do
    case Poison.encode(body) do
      {:ok, encoded_body} ->
        HTTPoison.put(url, encoded_body, headers, options)
      {:error, error} ->
        {:error, %Error{type: :json_encode_failed, message: inspect(error)}}
    end
  end

  @spec patch(binary, any, list, list) :: any
  def patch(url, body, headers \\ [], options \\ []) do
    case Poison.encode(body) do
      {:ok, encoded_body} ->
        HTTPoison.patch(url, encoded_body, headers, options)
      {:error, error} ->
        {:error, %Error{type: :json_encode_failed, message: inspect(error)}}
    end
  end

  @spec default_headers() :: list
  defp default_headers do
    token = Application.get_env(:elidactyl, :pterodactyl_auth_token)

    [
      {"Authorization", "Bearer #{token}"},
      {"Accept", "application/vnd.pterodactyl.v1+json; charset=utf-8"},
      {"Content-type", "application/json"}
    ]
  end

  @spec handle_response({:ok, Response.t()} | {:error, HTTPError.t()}) :: {:ok, binary} |  {:error, Error.t()}
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

  def handle_response({:error, %HTTPError{reason: reason}}) do
    {:error, %Error{type: :http_request_failed, message: inspect(reason)}}
  end
end
