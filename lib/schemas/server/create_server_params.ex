defmodule Elidactyl.Schemas.Server.CreateServerParams do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset

  alias Elidactyl.Schemas.Server.FeatureLimits
  alias Elidactyl.Schemas.Server.Limits
  alias Elidactyl.Schemas.Server.Allocation

  @type t :: %__MODULE__{
          external_id: binary | nil,
          name: binary | nil,
          user: non_neg_integer | nil,
          description: binary | nil,
          egg: non_neg_integer | nil,
          pack: non_neg_integer | nil,
          docker_image: binary | nil,
          startup: binary | nil,
          environment: map | nil,
          limits: Limits.t() | nil,
          feature_limits: FeatureLimits.t() | nil,
          allocation: Allocation.t() | nil,
          start_on_completion: boolean | nil,
          skip_scripts: boolean | nil,
          oom_disabled: boolean | nil
        }

  @optional ~w[pack description external_id]a
  @mandatory ~w[start_on_completion name user egg docker_image startup environment skip_scripts oom_disabled]a
  @embedded ~w[limits feature_limits allocation]a

  @derive {Jason.Encoder, only: @mandatory ++ @optional ++ @embedded}

  @primary_key false
  embedded_schema do
    field(:external_id, :binary)
    field(:name, :string)
    field(:user, :integer)
    field(:description, :string)
    field(:egg, :integer)
    field(:pack, :integer)

    field(:docker_image, :string)
    field(:startup, :string)
    field(:environment, :map)

    embeds_one(:limits, Limits)
    embeds_one(:feature_limits, FeatureLimits)
    embeds_one(:allocation, Allocation)

    field(:start_on_completion, :boolean)
    field(:skip_scripts, :boolean)
    field(:oom_disabled, :boolean)
  end

  @spec changeset(%__MODULE__{}, map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory ++ @optional)
    |> Changeset.validate_required(@mandatory)
    |> Changeset.cast_embed(:limits, required: true, with: &limits_changeset/2)
    |> Changeset.cast_embed(:feature_limits, required: true, with: &feature_limits_changeset/2)
    |> Changeset.cast_embed(:allocation, required: true, with: &allocation_changeset/2)
    |> Changeset.validate_length(:external_id, min: 1, max: 191)
    |> Changeset.validate_length(:name, min: 1, max: 255)
    |> Changeset.validate_number(:pack, greater_than_or_equal_to: 0)
    |> Changeset.validate_length(:docker_image, max: 255)
  end

  @spec allocation_changeset(Allocation.t(), map) :: Changeset.t()
  defp allocation_changeset(%Allocation{} = changeset, params) do
    Allocation.changeset(changeset, params)
  end

  @spec limits_changeset(Limits.t(), map) :: Changeset.t()
  defp limits_changeset(%Limits{} = changeset, params) do
    Limits.changeset(changeset, params)
  end

  @spec feature_limits_changeset(FeatureLimits.t(), map) :: Changeset.t()
  defp feature_limits_changeset(%FeatureLimits{} = changeset, params) do
    FeatureLimits.changeset(changeset, params)
  end
end
