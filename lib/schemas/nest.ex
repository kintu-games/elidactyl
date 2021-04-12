defmodule Elidactyl.Schemas.Nest do
  @moduledoc false

  use Ecto.Schema

  alias Elidactyl.Response.Parser
  alias Elidactyl.Utils

  @behaviour Parser

  @type t :: %__MODULE__{
    id: non_neg_integer | nil,
    uuid: Ecto.UUID.t | nil,
    author: binary | nil,
    name: binary | nil,
    description: binary | nil,
    created_at: NaiveDateTime.t | nil,
    updated_at: NaiveDateTime.t | nil,
  }

  defstruct ~w[id uuid author name description created_at updated_at]a

  @impl Parser
  def parse(%{"object" => "nest", "attributes" => attributes}) do
    struct(__MODULE__, attributes |> Utils.keys_to_atoms() |> Utils.parse_timestamps())
  end
end
