defmodule Elidactyl.MockedServer.ExternalSchema.Node do
  @moduledoc false
  @derive Jason.Encoder
  defstruct object: "node", attributes: %{}
end
