defmodule Elidactyl.Schemas.Nest do
  @moduledoc false

  use Ecto.Schema

  alias Elidactyl.Response.Parser
  alias Elidactyl.Utils

  @behaviour Parser

  @type t :: %__MODULE__{}

  defstruct ~w[id uuid author name description created_at updated_at]a

  @impl Parser
  def parse(%{"object" => "nest", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
