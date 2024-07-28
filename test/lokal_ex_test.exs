defmodule LokalExTest do
  use ExUnit.Case
  doctest LokalEx

  test "greets the world" do
    assert LokalEx.hello() == :world
  end
end
