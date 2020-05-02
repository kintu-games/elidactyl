defmodule Elidactyl.Server do
  use Ecto.Schema
  alias Elidactyl.FailureLimits
  alias Elidactyl.ServerLimits
  alias Elidactyl.ServerContainer
  alias Elidactyl.Utils

  @optional [:password, :language, :root_admin, :external_id]
  @mandatory [:username, :email, :first_name, :last_name]

  @derive {Poison.Encoder, only: @optional ++ @mandatory}
  embedded_schema do
    field :uuid, Ecto.UUID
    field :name, :string
    field :identifier, :string
    field :description, :string
    field :server_owner, :string

    embeds_one :limits, ServerLimits do
      field :memory, :integer
      field :swap, :integer
      field :disk, :integer
      field :io, :integer
      field :cpu, :integer
    end

    embeds_one :feature_limits, FailureLimits do
      field :databases, :integer
      field :allocations, :integer
    end

    field :user, :integer
    field :node, :integer
    field :allocation, :integer
    field :nest, :integer
    field :egg, :integer
    field :pack, :string

    embeds_one :container, ServerContainer do
      field :startup_command, :string
      field :image, :string
      field :installed, :boolean
      field :environment, :map
    end

    field :created_at, :naive_datetime
    field :updated_at, :naive_datetime
  end


  def parse(%{"object" => "server", "attributes" => %{"container" => %{"environment" => _}} = attributes}) do
    {unsafe_value, safe_attributes} = pop_in(attributes, ["container", "environment"])
    server = struct(__MODULE__, Utils.keys_to_atoms(safe_attributes))
    put_in(server, [Access.key!(:container), :environment], unsafe_value)
  end

  def parse(%{"object" => "server", "attributes" => attributes}) do
    struct(__MODULE__, Utils.keys_to_atoms(attributes))
  end

#  def changeset(struct, params) do
#    struct
#    |> Ecto.Changeset.cast(params, @mandatory ++ @optional)
#    |> Ecto.Changeset.validate_required(@mandatory)
#    |> Ecto.Changeset.validate_format(:email, ~r/.+@.+\..+/)
#    |> Ecto.Changeset.validate_length(:external_id, min: 1, max: 255)
#    |> Ecto.Changeset.validate_length(:username, min: 1, max: 255)
#    |> Ecto.Changeset.validate_length(:first_name, min: 1, max: 255)
#    |> Ecto.Changeset.validate_length(:last_name, min: 1, max: 255)
#  end
end