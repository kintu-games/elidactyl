defmodule Elidactyl.Request do
  @moduledoc false
  alias HTTPoison.Response
  alias HTTPoison.Error, as: HTTPError
  alias Elidactyl.Error

  @type request_options :: [{:use_client_api, boolean}]
  @type headers :: [{binary, binary}]
  @type http_method :: :get | :post | :delete | :put | :patch

  @spec request(http_method(), binary(), any(), headers(), request_options()) :: {:ok, any()} | {:error, Error.t()}
  def request(http_method, path, data \\ "", headers \\ [], opts \\ []) do
    url = Application.get_env(:elidactyl, :pterodactyl_url) <> path
    headers = opts |> default_headers() |> merge_headers(headers)
    options = [ssl: [{:versions, [:"tlsv1.2"]}], recv_timeout: 30_000]

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
    case Jason.encode(body) do
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
    case Jason.encode(body) do
      {:ok, encoded_body} ->
        HTTPoison.put(url, encoded_body, headers, options)
      {:error, error} ->
        {:error, %Error{type: :json_encode_failed, message: inspect(error)}}
    end
  end

  @spec patch(binary, any, list, list) :: any
  def patch(url, body, headers \\ [], options \\ []) do
    case Jason.encode(body) do
      {:ok, encoded_body} ->
        HTTPoison.patch(url, encoded_body, headers, options)
      {:error, error} ->
        {:error, %Error{type: :json_encode_failed, message: inspect(error)}}
    end
  end

  @spec default_headers(Keyword.t()) :: [{String.t(), String.t()}]
  defp default_headers(opts) do
    token =
      if Keyword.get(opts, :use_client_api) do
        Application.get_env(:elidactyl, :pterodactyl_client_auth_token)
      else
        Application.get_env(:elidactyl, :pterodactyl_server_auth_token)
      end

    [
      {"Authorization", "Bearer #{token}"},
      {"Accept", "application/vnd.pterodactyl.v1+json; charset=utf-8"},
      {"Content-type", "application/json"}
    ]
  end

  @spec handle_response({:ok, Response.t()} | {:error, HTTPError.t()}) :: {:ok, any()} |  {:error, Error.t()}
  def handle_response({:ok, %Response{status_code: 204}}), do: {:ok, ""}
  def handle_response({:ok, %Response{status_code: code, body: body}}) when code in 200..207 do
    case Jason.decode(body) do
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

  defp merge_headers(a, b) do
    a
    |> Enum.into(%{})
    |> Map.merge(Enum.into(b, %{}))
    |> Enum.into([])
  end
end
