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
      assert is_monodic(either(1, 1))
      assert is_monodic(left(1))
      assert is_monodic(right(1))

      assert not is_monodic({})
      assert not is_monodic(%{})
      assert not is_monodic(nil)
      assert not is_monodic("")
    end
  end

  describe "operations" do
    test "map" do
      res =
        {:ok, 1}
        |> map(fn x -> {:ok, x + 1} end)
        |> map(fn y -> y + 1 end)

      assert res == 3
    end

    test "~>>" do
      res =
        left("left")
        ~>> fn l -> left(String.upcase(l)) end

      assert {Dreamy.Either, "LEFT", nil} = res
    end

    test "flat_map" do
      res =
        left("left")
        |> flat_map(fn l -> left(String.upcase(l)) end)

      assert {Dreamy.Either, "LEFT", nil} = res
    end
  end
end
