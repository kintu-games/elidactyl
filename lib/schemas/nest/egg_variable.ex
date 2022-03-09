defmodule Elidactyl.Schemas.Nest.EggVariable do
  @moduledoc false

  alias Elidactyl.Response.Parser
  alias Elidactyl.Utils

  @behaviour Parser

  @type t :: %__MODULE__{
          id: non_neg_integer | nil,
          egg_id: non_neg_integer | nil,
          name: binary | nil,
          description: binary | nil,
          env_variable: binary | nil,
          default_value: binary | nil,
          user_viewable: boolean | nil,
          user_editable: boolean | nil,
          rules: binary | nil
        }

  defstruct ~w[id egg_id name description env_variable default_value user_viewable user_editable rules]a

  @impl Parser
  def parse(%{"object" => "egg_variable", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end
