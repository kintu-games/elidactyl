defmodule Elidactyl.ChangesetCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import unquote(__MODULE__), only: [
        assert_invalid: 2, assert_invalid: 3,
        assert_valid: 1, assert_valid: 2
      ]
    end
  end

  @doc """
  Asserts that the given changeset is invalid, and that when the assertion_expression is applied to
  the error_message it results in a truthy value.
  """
  defmacro assert_invalid(changeset, field) when is_atom(field) do
    quote do
      c = unquote(changeset)

      with :non_valid_changeset <- unquote(__MODULE__).validate_changeset(c),
           :ok <- unquote(__MODULE__).validate_field(c, unquote(field)),
           {message, _opts} <- Keyword.get(c.errors, unquote(field)) do
        assert true
      else
        :invalid_changeset ->
          raise "assert_invalid/2 requires a changeset for the first argument"

        :valid_changeset ->
          flunk("#{inspect(c.data.__struct__)} is valid, expected at least one field to be invalid")

        :invalid_field ->
          raise "field :#{unquote(field)} not found in #{inspect(c.data.__struct__)}"

        _ ->
          flunk(":#{unquote(field)} field is valid, expected it to be invalid")
      end
    end
  end
  defmacro assert_invalid(changeset, field, assertion_expression) when is_atom(field) do
    expr = Macro.to_string(assertion_expression)
    quote do
      c = unquote(changeset)

      with :non_valid_changeset <- unquote(__MODULE__).validate_changeset(c),
           :ok <- unquote(__MODULE__).validate_field(c, unquote(field)),
           {message, _opts} <- Keyword.get(c.errors, unquote(field)) do
        var!(error_message) = message
        if unquote(assertion_expression) do
          assert true
        else
          flunk """
          Expression did not match error message
          #{IO.ANSI.cyan()}error_message:#{IO.ANSI.reset()} #{inspect(message)}
          #{IO.ANSI.cyan()}expression:#{IO.ANSI.reset()} #{unquote(expr)}
          """
        end
      else
        :invalid_changeset ->
          raise "assert_invalid/3 requires a changeset for the first argument"

        :valid_changeset ->
          flunk("#{inspect(c.data.__struct__)} is valid, expected at least one field to be invalid")

        :invalid_field ->
          raise "field :#{unquote(field)} not found in #{inspect(c.data.__struct__)}"

        _ ->
          flunk(":#{unquote(field)} field is valid, expected it to be invalid")
      end
    end
  end

  defmacro assert_valid(changeset) do
    quote do
      c = unquote(changeset)

      with :valid_changeset <- unquote(__MODULE__).validate_changeset(c) do
        assert true
      else
        :invalid_changeset ->
          raise "assert_valid/2 requires a changeset for the first argument"

        :valid_changeset ->
          flunk("#{inspect(c.data.__struct__)} is invalid, expected to be valid")
        end
    end
  end
  defmacro assert_valid(changeset, field) when is_atom(field) do
    quote do
      c = unquote(changeset)

      with valid when valid != :invalid_changeset <- unquote(__MODULE__).validate_changeset(c),
           :ok <- unquote(__MODULE__).validate_field(c, unquote(field)),
           nil <- Keyword.get(c.errors, unquote(field)) do
        assert true
      else
        :invalid_changeset ->
          raise "assert_valid/2 requires a changeset for the first argument"

        :invalid_field ->
          raise "field :#{unquote(field)} not found in #{inspect(c.data.__struct__)}"

        _ ->
          flunk(":#{unquote(field)} field is invalid, expected it to be valid")
      end
    end
  end

  def validate_changeset(%Ecto.Changeset{valid?: true}), do: :valid_changeset
  def validate_changeset(%Ecto.Changeset{}), do: :non_valid_changeset
  def validate_changeset(_), do: :invalid_changeset

  def validate_field(%Ecto.Changeset{data: data}, field) do
    if data |> Map.keys() |> Enum.member?(field) do
      :ok
    else
      :invalid_field
    end
  end
  def validate_field(_, _), do: :invalid_changeset
end
