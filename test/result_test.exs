defmodule DreamyResultTest do
  @moduledoc false

  use ExUnit.Case
  use Dreamy
  doctest Dreamy.Result

  describe "guards" do
    test "is_result" do
      assert is_result(ok(123))
      assert is_result(error(123))
      assert not is_result(123)
    end

    test "is_ok" do
      assert is_ok(ok(123))
      assert not is_ok(error(123))
      assert not is_ok(123)
    end

    test "is_error" do
      assert is_error(error(123))
      assert not is_error(ok(123))
      assert not is_error(123)
    end
  end
end
