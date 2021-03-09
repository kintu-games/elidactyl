defmodule Elidactyl.MockedServer.ExternalSchema.Server do
  @moduledoc false
  @derive Jason.Encoder
  defstruct object: "server", attributes: %{}
end
