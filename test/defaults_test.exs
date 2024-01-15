defmodule DreamyDefaultsTest do
  @moduledoc false

  use ExUnit.Case
  use Dreamy

  doctest Dreamy.Defaults

  describe "parsers" do
    test "parse_defaults" do
      assert_raise RuntimeError, fn ->
        parse_defaults!(nil, nil)
      end
    end

    test "parse_bool" do
      trues = [
        "true",
        "t",
        "y",
        "yes",
        "1"
      ]

      (Enum.map(trues, &String.upcase/1) ++ trues)
      |> Enum.map(&parse_bool/1)
      |> Enum.each(&assert/1)

      falses = [
        "false",
        "f",
        "n",
        "no",
        "0"
      ]

      (Enum.map(falses, &String.upcase/1) ++ falses)
      |> Enum.map(&parse_bool/1)
      |> Enum.each(&assert not &1)

      assert parse_bool("", default: true)
      assert parse_bool(1, default: true)
      assert parse_bool({}, default: true)

      assert not parse_bool([], default: false)
      assert not parse_bool(nil, default: false)
      assert not parse_bool(%{}, default: false)
    end
  end
end
