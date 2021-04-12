defmodule Elidactyl.MockedServer.ExternalSchema.User do
  @moduledoc false
  @derive Jason.Encoder
  defstruct object: "user", attributes: %{}
end
