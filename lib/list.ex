defmodule Elidactyl.List do
  alias Elidactyl.Response

  @derive {Poison.Encoder, only: [:object, :data]}

  defstruct object: "list", data: []

  def parse(%{object: "list", data: data}) do
    Enum.map(data, &Response.parse_response/1)
  end
end
