defmodule Elidactyl.Schemas.Server.CreateParams do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset

  alias Elidactyl.Schemas.Server.FeatureLimits
  alias Elidactyl.Schemas.Server.Limits
  alias Elidactyl.Schemas.Server.Allocation
  alias Elidactyl.Schemas.Server.Deploy

  @type t :: %__MODULE__{}

  @mandatory [
    :name,
    :description,
    :egg,
    :pack,

    :docker_image,
    :startup,
    :environment,

    :start_on_completion,
    :skip_scripts,
    :oom_disabled
  ]


  @derive {Poison.Encoder, only: @mandatory}

  embedded_schema do
    field :external_id, :binary
    field :name, :string
    field :description, :string
    field :egg, :integer
    field :pack, :integer

    field :docker_image, :string
    field :startup, :string
    field :environment, :map

    embeds_one :limits, Limits
    embeds_one :feature_limits, FeatureLimits
    embeds_one :allocation, Allocation
    embeds_one :deploy, Deploy

    field :start_on_completion, :boolean
    field :skip_scripts, :boolean
    field :oom_disabled, :boolean
  end

  @spec changeset(t(), map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.cast_embed(:limits, required: true, with: &limits_changeset/2)
    |> Changeset.cast_embed(:feature_limits, required: true, with: &feature_limits_changeset/2)
    |> Changeset.cast_embed(:allocation, required: true, with: &allocation_changeset/2)
    |> Changeset.cast_embed(:deploy, required: true, with: &deploy_changeset/2)
    |> Changeset.validate_length(:external_id, min: 1, max: 191)
    |> Changeset.validate_length(:name, min: 1, max: 255)
    |> Changeset.validate_number(:pack, greater_than_or_equal_to: 0)
    |> Changeset.validate_length(:docker_image, max: 255)
  end

  @spec allocation_changeset(Changeset.t(), map) :: Changeset.t()
  defp allocation_changeset(%Allocation{} = changeset, params) do
    Changeset.cast(changeset, params, Allocation.__schema__(:fields))
  end

  @spec deploy_changeset(Changeset.t(), map) :: Changeset.t()
  defp deploy_changeset(%Deploy{} = changeset, params) do
    Changeset.cast(changeset, params, Deploy.__schema__(:fields))
  end

  @spec limits_changeset(Changeset.t(), map) :: Changeset.t()
  defp limits_changeset(%Limits{} = changeset, params) do
    Changeset.cast(changeset, params, Limits.__schema__(:fields))
  end

  @spec feature_limits_changeset(Changeset.t(), map) :: Changeset.t()
  defp feature_limits_changeset(%FeatureLimits{} = changeset, params) do
    Changeset.cast(changeset, params, FeatureLimits.__schema__(:fields))
  end
end