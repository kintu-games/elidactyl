defmodule Elidactyl.RequestTest do
  use ExUnit.Case
  alias Elidactyl.Request

  test "basic requests to mocked server" do
    assert {:ok, %{:type => "get"}} == Request.request(:get, "/test", "", [])
    assert {:ok, %{:type => "post", :params => %{:_json => "{}"}}} == Request.request(:post, "/test", "{}", [])
    assert {:ok, %{:type => "delete"}} == Request.request(:delete, "/test", "", [])
    assert {:ok, %{:type => "put"}} == Request.request(:put, "/test", "", [])

    assert {:error, {:http_request_failed, 404, "error"}} ==
      Request.request(:get, "/test_not_found", "", [])
  end
end
