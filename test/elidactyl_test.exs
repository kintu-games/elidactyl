defmodule ElidactylTest do
  use ExUnit.Case
  doctest Elidactyl

  test "greets the world" do
    assert Elidactyl.hello() == :world
  end
end
