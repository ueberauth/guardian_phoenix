defmodule GuardianPhoenixTest do
  use ExUnit.Case
  doctest GuardianPhoenix

  test "greets the world" do
    assert GuardianPhoenix.hello() == :world
  end
end
