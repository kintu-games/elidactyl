defmodule Elidactyl.MockedServer.Router.Utils do
  @moduledoc false

  def success(conn, body, code \\ 200) do
    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.resp(code, Poison.encode!(body))
    |> Plug.Conn.send_resp()
  end

  def failure(conn, status, error_msg \\ "error") do
    conn
    |> Plug.Conn.resp(status, error_msg)
    |> Plug.Conn.send_resp()
  end
end