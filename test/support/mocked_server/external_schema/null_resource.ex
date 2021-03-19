defmodule Elidactyl.MockedServer.ExternalSchema.NullResource do
  @moduledoc false
  @derive Jason.Encoder
  defstruct object: "null_resource", attributes: nil
end
