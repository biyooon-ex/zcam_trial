defmodule McamElixirTest do
  use ExUnit.Case
  doctest McamElixir

  test "greets the world" do
    assert McamElixir.hello() == :world
  end
end
