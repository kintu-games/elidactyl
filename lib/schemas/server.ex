defmodule Elidactyl.Schemas.Server do
  @moduledoc false

  use Ecto.Schema

  alias Elidactyl.Schemas.Server.Container
  alias Elidactyl.Schemas.Server.FeatureLimits
  alias Elidactyl.Schemas.Server.Limits
  alias Elidactyl.Schemas.Server.Database
  alias Elidactyl.Utils
  alias Elidactyl.Response
  alias Elidactyl.Response.Parser

  @behaviour Parser

  @type t :: %__MODULE__{}

  @optional ~w[password language root_admin external_id description oom_disabled name]a
  @mandatory ~w[user limits egg environment feature_limits start_on_completion skip_scripts startup docker_image pack]a

  @derive {Jason.Encoder, only: @optional ++ @mandatory ++ ~w[allocation]a}

  embedded_schema do
    field :external_id, :string
    field :uuid, Ecto.UUID
    field :identifier, :string
    field :name, :string
    field :description, :string
    field :suspended, :boolean

    embeds_one :limits, Limits
    embeds_one :feature_limits, FeatureLimits
    embeds_many :databases, Database

    field :user, :integer
    field :server_owner, :boolean
    field :node, :integer
    field :allocation, :integer
    field :nest, :integer
    field :egg, :integer
    field :pack, :integer

    embeds_one :container, Container

    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end

  @impl Parser
  def parse(%{"object" => "server", "attributes" => attributes}) do
    attributes =
      attributes
      |> parse_container()
      |> parse_relationships()
      |> Map.drop(~w[relationships])
      |> Utils.keys_to_atoms(~w[container])
    struct(__MODULE__, attributes)
  end

  defp parse_container(%{"container" => %{} = cont} = attributes) do
    cont = Response.parse_response(cont, Container)
    Map.put(attributes, "container", cont)
  end
  defp parse_container(%{"container" => _} = attributes), do: Map.delete(attributes, "container")
  defp parse_container(attributes), do: attributes

  @relationships_atoms ~w[databases]a
  @relationships Enum.map(@relationships_atoms, &to_string/1)
  defp parse_relationships(%{"relationships" => %{} = rels} = attributes) do
    rels =
      rels
      |> Map.take(@relationships)
      |> Enum.into(%{}, fn {k, v} -> {String.to_existing_atom(k), Response.parse_response(v)} end)
    Map.put(attributes, "databases", Map.get(rels, :databases, []))
  end
  defp parse_relationships(%{"relationships" => _} = attributes), do: Map.delete(attributes, "relationships")
  defp parse_relationships(attributes), do: attributes
end
