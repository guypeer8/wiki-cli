defmodule WikiTest do
  use ExUnit.Case
  doctest Wiki

  test "greets the world" do
    assert Wiki.hello() == :world
  end
end
