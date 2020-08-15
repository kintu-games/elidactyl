defmodule Elidactyl.Error do
  @moduledoc """
  Error struct that contains response from pterodactyl panel.
  """

  @type t :: %__MODULE__{}
  defstruct type: nil, message: nil, details: %{}
end