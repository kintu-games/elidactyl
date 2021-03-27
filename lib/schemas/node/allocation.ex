defmodule Elidactyl.Schemas.Node.Allocation do
  @moduledoc false

  use Ecto.Schema

  alias Elidactyl.Utils
  alias Elidactyl.Response.Parser

  @behaviour Parser

  defstruct ~w[id ip alias port notes assigned]a

  @type t :: %__MODULE__{}

  @impl Parser
  def parse(%{"object" => "allocation", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
