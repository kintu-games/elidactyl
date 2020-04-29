defmodule Elidactyl.Error do
#  @derive {Inspect, only: [:type, :message]}

  @type t :: %__MODULE__{}
  defstruct type: nil, message: nil, details: %{}
end