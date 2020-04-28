defmodule Elidactyl.User do
  @derive {Poison.Encoder, only: [:object, :attributes]}
  defstruct object: "user",
            attributes: %{
              id: nil,
              external_id: nil,
              uuid: nil,
              username: nil,
              email: nil,
              first_name: nil,
              last_name: nil,
              password: nil,
              "2fa": nil,
              root_admin: nil,
              language: nil,
              created_at: nil,
              updated_at: nil
            }

  def parse(%{object: "user"} = map) do
    struct(__MODULE__, map)
  end
end