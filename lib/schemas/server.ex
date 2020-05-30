defmodule Elidactyl.Schemas.Server do
  use Ecto.Schema

  alias Elidactyl.Schemas.Server.Container
  alias Elidactyl.Schemas.Server.FeatureLimits
  alias Elidactyl.Schemas.Server.Limits

  alias Elidactyl.Utils

  @type t :: %__MODULE__{}

  @optional [:password, :language, :root_admin, :external_id]
  @mandatory [
    :name,
    :user,
    :limits,
    :egg,
    :environment,
    :feature_limits,
    :deploy,
    :start_on_completion,
    :skip_scripts,
    :oom_disabled,
    :startup,
    :docker_image,
    :pack,
    :description
  ]

  @derive {Poison.Encoder, only: @optional ++ @mandatory}
  embedded_schema do
    field :external_id, :string
    field :uuid, Ecto.UUID
    field :identifier, :string
    field :name, :string
    field :description, :string
    field :suspended, :boolean

    embeds_one :limits, Limits

    embeds_one :feature_limits, FeatureLimits

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

  @spec parse(map) :: t()
  def parse(
        %{
          "object" => "server",
          "attributes" => %{
            "container" => %{
              "environment" => _
            }
          } = attributes
        }
      ) do
    {unsafe_value, safe_attributes} = pop_in(attributes, ["container", "environment"])
    server = struct(__MODULE__, Utils.keys_to_atoms(safe_attributes))
    put_in(server, [Access.key!(:container), :environment], unsafe_value)
  end

  def parse(%{"object" => "server", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end
end