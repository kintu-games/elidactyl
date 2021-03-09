defmodule Elidactyl.MockedServer.ExternalSchema.List do
  @moduledoc false
  @derive Jason.Encoder
  defstruct object: "list", data: [], meta: %{}
end
