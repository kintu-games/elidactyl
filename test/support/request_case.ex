defmodule Elidactyl.RequestCase do
  use ExUnit.CaseTemplate

  alias Elidactyl.MockedServer

  using do
    quote do
      setup do
        on_exit(fn -> unquote(MockedServer).cleanup() end)
      end
    end
  end
end
