defmodule Elidactyl.Schemas.Server.UpdateBuildInfoParams do
  @moduledoc false

  use Ecto.Schema
  alias Ecto.Changeset

  alias Elidactyl.Schemas.Server.FeatureLimits

  @type t :: %__MODULE__{
          allocation: pos_integer | nil,
          memory: non_neg_integer | nil,
          swap: integer | nil,
          io: non_neg_integer | nil,
          cpu: non_neg_integer | nil,
          disk: non_neg_integer | nil,
          threads: binary | nil,
          feature_limits: FeatureLimits.t() | nil
        }

  @mandatory ~w[allocation memory swap io cpu disk]a
  @embedded ~w[feature_limits]a

  @derive {Jason.Encoder, only: @mandatory ++ @embedded ++ ~w[threads]a}

  @primary_key false
  embedded_schema do
    field(:allocation, :integer)
    field(:memory, :integer)
    field(:swap, :integer)
    field(:io, :integer)
    field(:cpu, :integer)
    field(:disk, :integer)
    field(:threads, :string)
    embeds_one(:feature_limits, FeatureLimits)
  end

  @spec changeset(t, map) :: Changeset.t()
  def changeset(struct, params) do
    struct
    |> Changeset.cast(params, @mandatory)
    |> Changeset.validate_required(@mandatory)
    |> cast_threads(params)
    |> Changeset.cast_embed(:feature_limits, required: true, with: &feature_limits_changeset/2)
    |> Changeset.validate_number(:allocation, greater_than: 0)
    |> Changeset.validate_number(:memory, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:swap, greater_than_or_equal_to: -1)
    |> Changeset.validate_number(:io, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:cpu, greater_than_or_equal_to: 0)
    |> Changeset.validate_number(:cpu, less_than_or_equal_to: 100)
    |> Changeset.validate_number(:disk, greater_than_or_equal_to: 0)
    |> validate_threads()
  end

  defp cast_threads(%Changeset{} = changeset, params) do
    case Map.get(params, "threads", Map.get(params, :threads)) do
      nil -> changeset
      "" -> changeset
      threads when is_integer(threads) -> Changeset.put_change(changeset, :threads, "#{threads}")
      threads when is_binary(threads) -> Changeset.put_change(changeset, :threads, threads)
      _ -> put_thread_error(changeset)
    end
  end

  defp feature_limits_changeset(%FeatureLimits{} = changeset, params) do
    Changeset.cast(changeset, params, FeatureLimits.__schema__(:fields))
  end

  defp validate_threads(%Changeset{changes: %{threads: nil}} = changeset), do: changeset

  defp validate_threads(%Changeset{changes: %{threads: threads}} = changeset)
       when is_binary(threads) do
    threads
    |> String.split(",")
    |> Enum.reduce_while(:ok, fn thread, _ ->
      thread |> String.split("-", parts: 2) |> validate_thread_number()
    end)
    |> case do
      :ok -> changeset
      _ -> put_thread_error(changeset)
    end
  end

  defp validate_threads(%Changeset{changes: %{threads: _}} = changeset) do
    put_thread_error(changeset)
  end

  defp validate_threads(changeset), do: changeset

  defp put_thread_error(changeset) do
    error =
      "Invalid format. Threads can be a single number, or a comma seperated list. " <>
        "Example: 0, 0-1,3, or 0,1,3,4."

    Changeset.add_error(changeset, :threads, error)
  end

  defp validate_thread_number([thread]) do
    case Integer.parse(thread) do
      {_, ""} -> {:cont, :ok}
      _ -> {:halt, :error}
    end
  end

  defp validate_thread_number([from, to]) do
    case {Integer.parse(from), Integer.parse(to)} do
      {{from, ""}, {to, ""}} when from <= to -> {:cont, :ok}
      _ -> {:halt, :error}
    end
  end

  defp validate_thread_number(_), do: {:halt, :error}
end
