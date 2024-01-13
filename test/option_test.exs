defmodule DreamyOptionTest do
  @moduledoc false

  use ExUnit.Case
  use Dreamy
  doctest Dreamy.Option

  describe "guards" do
    test "is_option/1" do
      assert is_option(option(123))
      assert is_option(empty())
      assert not is_option(123)
    end

    test "is_empty/1" do
      assert is_empty(empty())
      assert is_empty(option(nil))
      assert not is_empty(option(true))
    end

    test "is_some/1" do
      assert is_some(option(true))
      assert not is_some(empty())
      assert not is_some(option(nil))
    end
  end
end
