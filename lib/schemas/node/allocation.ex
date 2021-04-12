defmodule Elidactyl.Schemas.Node.Allocation do
  @moduledoc false

  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  @type t :: %__MODULE__{
    id: non_neg_integer | nil,
    ip: binary | nil,
    alias: binary | nil,
    port: binary | nil,
    assigned: boolean | nil,
  }

  defstruct ~w[id ip alias port notes assigned]a

  @impl Parser
  def parse(%{"object" => "allocation", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
