defmodule DreamyEitherTest do
  @moduledoc false

  use ExUnit.Case
  use Dreamy

  doctest Dreamy.Either

  describe "guards" do
    test "is_either/1" do
      assert is_either(either(:l, :r))
      assert is_either(either(nil, nil))
      assert is_either(left(:l))
      assert is_either(right(:r))
      assert is_either({Either, :l, :r})
      assert is_either(neither())
      assert not is_either(option(:l))
      assert not is_either(empty())
      assert not is_either({:ok, :l})
      assert not is_either(nil)
    end

    test "is_left/1" do
      assert is_left(left(:l))
      assert is_left({Either, :l, nil})
      assert not is_left(either(:l, :r))
      assert not is_left(either(nil, nil))
      assert not is_left(right(:r))
      assert not is_left({Either, :l, :r})
      assert not is_left(option(:l))
      assert not is_left(empty())
      assert not is_left({:ok, :l})
      assert not is_left(nil)
      assert not is_left(neither())
    end

    test "is_right/1" do
      assert is_right(right(:r))
      assert is_right({Either, nil, :r})
      assert not is_right(left(:l))
      assert not is_right({Either, :l, nil})
      assert not is_right(either(:l, :r))
      assert not is_right(either(nil, nil))
      assert not is_right({Either, :l, :r})
      assert not is_right(option(:l))
      assert not is_right(empty())
      assert not is_right({:ok, :l})
      assert not is_right(nil)
      assert not is_right(neither())
    end

    test "is_neither/1" do
      assert is_neither(neither())
      assert is_neither(either(nil, nil))
      assert not is_neither(right(:r))
      assert not is_neither({Either, nil, :r})
      assert not is_neither(left(:l))
      assert not is_neither({Either, :l, nil})
      assert not is_neither(either(:l, :r))
      assert not is_neither({Either, :l, :r})
      assert not is_neither(option(:l))
      assert not is_neither(empty())
      assert not is_neither({:ok, :l})
      assert not is_neither(nil)
    end
  end
end
