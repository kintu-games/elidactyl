defmodule Elidactyl.RequestTest do
  use ExUnit.Case
  alias Elidactyl.Request
  alias Elidactyl.Error

  test "basic requests to mocked server" do
    assert {:ok, %{:type => "get"}} == Request.request(:get, "/test", "", [])
    assert {:ok, %{:type => "post", :params => %{:_json => "{}"}}} == Request.request(:post, "/test", "{}", [])
    assert {:ok, %{:type => "delete"}} == Request.request(:delete, "/test", "", [])
    assert {:ok, %{:type => "put"}} == Request.request(:put, "/test", "", [])

    assert {:error, %Error{type: :http_request_failed, details: %{code: 404, body: "error", url: url}, message: msg}} =
      Request.request(:get, "/test_not_found", "", [])
    assert msg =~ "404"
    assert msg =~ "/test_not_found"
    assert url =~ "/test_not_found"
  end
end
