defmodule Elidactyl.MockedServer.ExternalSchema.Server.Database do
  @moduledoc false
  @derive Jason.Encoder
  defstruct object: "database", attributes: %{}
end
