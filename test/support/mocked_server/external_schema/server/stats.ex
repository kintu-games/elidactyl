defmodule Elidactyl.MockedServer.ExternalSchema.Server.Stats do
  @moduledoc false
  @derive Jason.Encoder
  defstruct object: "stats", attributes: %{}
end
