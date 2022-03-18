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

  @type t :: %__MODULE__{
          id: non_neg_integer | nil,
          external_id: binary | nil,
          uuid: Ecto.UUID.t() | nil,
          identifier: binary | nil,
          name: binary | nil,
          description: binary | nil,
          suspended: boolean | nil,
          limits: Limits.t() | nil,
          feature_limits: FeatureLimits.t() | nil,
          databases: [Database.t()] | nil,
          user: non_neg_integer | nil,
          server_owner: boolean | nil,
          node: non_neg_integer | nil,
          allocation: non_neg_integer | nil,
          nest: non_neg_integer | nil,
          egg: non_neg_integer | nil,
          pack: non_neg_integer | nil,
          container: Container.t() | nil,
          created_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  @encode_keys ~w[external_id uuid identifier name description suspended user server_owner node allocation nest egg pack]a

  @derive {Jason.Encoder, only: @encode_keys}

  embedded_schema do
    field(:external_id, :string)
    field(:uuid, Ecto.UUID)
    field(:identifier, :string)
    field(:name, :string)
    field(:description, :string)
    field(:suspended, :boolean)

    embeds_one(:limits, Limits)
    embeds_one(:feature_limits, FeatureLimits)
    embeds_many(:databases, Database)

    field(:user, :integer)
    field(:server_owner, :boolean)
    field(:node, :integer)
    field(:allocation, :integer)
    field(:nest, :integer)
    field(:egg, :integer)
    field(:pack, :integer)

    embeds_one(:container, Container)

    field(:created_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
  end

  @impl Parser
  def parse(%{"object" => "server", "attributes" => attributes}) do
    # loading for atoms
    %FeatureLimits{allocations: nil, databases: nil, backups: nil}

    attributes =
      attributes
      |> parse_container()
      |> parse_relationships()
      |> Map.drop(~w[relationships])
      |> Utils.keys_to_atoms(~w[container])
      |> Utils.parse_timestamps()

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

  defp parse_relationships(%{"relationships" => _} = attributes),
    do: Map.delete(attributes, "relationships")

  defp parse_relationships(attributes), do: attributes
end
