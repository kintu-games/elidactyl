defmodule Elidactyl.Schemas.Nest.EggVariable do
  @moduledoc false

  alias Elidactyl.Response.Parser
  alias Elidactyl.Utils

  @behaviour Parser

  defstruct ~w[
    id egg_id name description env_variable default_value user_viewable user_editable rules
    created_at updated_at]a

  @type t :: %__MODULE__{}

  @impl Parser
  def parse(%{"object" => "egg_variable", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
