defmodule Elidactyl.Error do
#  @derive {Inspect, only: [:type, :message]}

  defstruct type: nil, message: nil, details: %{}
end