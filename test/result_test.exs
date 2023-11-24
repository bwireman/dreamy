defmodule DreamyResultTest do
  @moduledoc false

  use ExUnit.Case
  use Dreamy
  doctest Dreamy.Result

  describe "is_result/1 guard" do
    test "✅" do
      assert (case ok(123) do
                v when is_result(v) -> true
                _ -> false
              end)

      assert (case error(123) do
                v when is_result(v) -> true
                _ -> false
              end)
    end

    test "X" do
      assert not (case(123) do
                    v when is_result(v) -> true
                    _ -> false
                  end)
    end
  end
end
