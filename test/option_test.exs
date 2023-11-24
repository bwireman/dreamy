defmodule DreamyOptionTest do
  @moduledoc false

  use ExUnit.Case
  use Dreamy
  doctest Dreamy.Option

  describe "is_option/1 guard" do
    test "✅" do
      assert (case option(123) do
                v when is_option(v) -> true
                _ -> false
              end)

      assert (case empty() do
                v when is_option(v) -> true
                _ -> false
              end)
    end

    test "X" do
      assert not (case 123 do
                    v when is_option(v) -> true
                    _ -> false
                  end)
    end
  end
end
