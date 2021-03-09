defmodule Elidactyl.Error do
  @moduledoc """
  Error struct that contains response from pterodactyl panel.
  """

  @type t :: %__MODULE__{
    type: atom() | nil,
    message: String.t() | nil,
    details: map,
  }

  defstruct type: nil, message: nil, details: %{}

  @doc """
  Makes error struct from ecto changeset
  """
  @spec from_changeset(Ecto.Changeset.t()) :: t()
  @spec from_changeset(Ecto.Changeset.t(), atom()) :: t()
  @spec from_changeset(Ecto.Changeset.t(), atom(), String.t() | nil) :: t()
  def from_changeset(changeset, type \\ :validation_error, msg \\ nil) do
    details =
      changeset
      |> Ecto.Changeset.traverse_errors(fn {msg, _opts} -> msg end)
      |> Enum.into(%{}, fn {field, messages} -> {field, Enum.join(messages, ", ")} end)

    %__MODULE__{type: type, message: msg, details: details}
  end
end
