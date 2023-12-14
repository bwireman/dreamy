defmodule DreamyMonodicTest do
  @moduledoc false

  use ExUnit.Case
  use Dreamy

  doctest Dreamy.Monodic

  describe "guards" do
    test "is_monodic" do
      assert is_monodic(ok(1))
      assert is_monodic(error(1))
      assert is_monodic(option(1))
      assert is_monodic(empty())

      assert not is_monodic({})
      assert not is_monodic(%{})
      assert not is_monodic(nil)
      assert not is_monodic("")
    end
  end
end
